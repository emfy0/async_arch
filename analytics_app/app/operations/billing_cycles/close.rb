module BillingCycles
  class Close
    # будет запускаться по крону

    def call
      current_cycle = BillingCycle.current.first

      return Failure('No active billing cycle found') unless current_cycle

      # так, очевидно, делать нельзя, потому что нельзя заретраить, но для этого проекта пойдет
      # в плане имплементации я бы разбил 2 крона, один для закрытия биллинг цикла, второй для выплаты
      # второй кнон будет прохожится по только что закрытому биллинг циклу и выплачивать деньги
      # таким образом можно реализовать безопасный ретрай (то есть будем скипать юзеров уже с пейментами)
      #
      # сами пейменты же обудут обрабатываться в отдельных воркерах

      ActiveRecord::Base.transaction do
        time = Time.current

        current_cycle.update!(active: false, end_date: time)
        BillingCycle.create!(start_date: time, active: true)
      end

      User
        .joins(:transactions)
        .select('users.*, SUM(transactions.debit) as debit, SUM(transactions.credit) as credit')
        .where(transactions: { billing_cycle: current_cycle })
        .group('users.id')
        .having('SUM(transactions.debit) > SUM(transactions.credit)')
        .find_each do |user|
          user.transaction do
            payment_value = user.debit - user.credit

            user.decrement!(:balance, payment_value)

            withdrawal = Transaction.create!(
              user:,
              kind: :withdrawal,
              billing_cycle: current_cycle,
              credit: payment_value
            )

            payment = Payment.create!(
              user:,
              billing_cycle: current_cycle,
              transaction: withdrawal,
              amount: payment_value
            )
          end
        end
    end
  end
end
