class TasksStreamConsumer < ApplicationConsumer
  include AnalyticsApp::Import['tasks.find_or_create']

  def consume
    messages.each do |message|
      payload = message.payload.deep_symbolize_keys!
      validate_event!(payload)

      case [payload[:event], payload[:event_version]]
      in 'TaskCreated', 1
        payload[:data] in task: { public_id:, name:, description:, user: { public_id: user_public_id } }

        jira_id = name[/\[\S+\]/]
        name = name.gsub(/\[\S+\]/, '')

        find_or_create.(
          { public_id:, name:, description:, user_public_id:, jira_id: }
        ).value!
      in 'TaskCreated', 2
        payload[:data] in task: { public_id:, name:, jira_id:, description:, user: { public_id: user_public_id } }

        find_or_create.(
          { public_id:, name:, description:, user_public_id:, jira_id: }
        ).value!
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

