class TopManagementProfitTransaction < BaseTransaction
  request_schema do
    hash_schema(
      token: string,
    )
  end

  map  :unwrap
  step :typecast
  step :validate_ststion_token, with: 'users.retrieve_user'
  step :authorize
  step :perform

  def authorize(input)
    user = input[:user]

    if user.role.in?(%w[admin])
      Success(input)
    else
      Failure(:not_found)
    end
  end

  def perform(input)
    current_time = Time.current

    profit =
      Transaction
        .where(created_at: current_time.beginning_of_day..current_time.end_of_day)
        .select('SUM(transactions.debit) - SUM(transactions.credit) AS profit')
        .limit(1)
        .to_a
        .first
        .profit

    negitive_profit_users = User
      .joins(:transactions)
      .group('users.id')
      .having('SUM(transactions.debit) - SUM(transactions.credit) < 0')
      .where(transactions: { created_at: current_time.beginning_of_day..current_time.end_of_day })
      .pluck(:username)

    Success(profit:, negitive_profit_users:)
  end
end
