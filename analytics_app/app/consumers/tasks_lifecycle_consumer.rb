class TasksLifecycleConsumer < ApplicationConsumer
  include AnalyticsApp::Import['tasks.find_or_create']

  def consume
    messages.each do |message|
      payload = message.payload.deep_symbolize_keys!
      validate_event!(payload)

      case [payload[:event], payload[:event_version]]
      in 'TaskAssigned', 1
        payload[:data] in task: { public_id:, user: { public_id: user_public_id } }

        task = find_or_create.(
          { public_id:, user_public_id: }
        ).value!

        billing_cycle = BillingCycle.current.first

        Transaction.transaction do
          user = task.user
          credit = task.penalty

          Transaction.create!(
            task:,
            user:,
            kind: :enrollment,
            billing_cycle:,
            credit:,
          )
          user.decrement!(:balance, credit)
        end
      in 'TaskCompleted', 1
        payload[:data] in task: { public_id: }

        task = Task.find_by(public_id:)
        billing_cycle = BillingCycle.current.first

        Transaction.transaction do
          user = task.user
          debit = task.reward

          Transaction.create!(
            task:,
            user:,
            kind: :compensation,
            billing_cycle:,
            debit:,
          )
          user.increment!(:balance, debit)
        end
      else
        Rails.logger.info("Unknown event: #{payload[:event]}")
      end

      mark_as_consumed(message)
    rescue => e
      Rails.logger.error("Error processing message: #{e.message}")
      dispatch_to_dlq(message)
    end
  end
end

