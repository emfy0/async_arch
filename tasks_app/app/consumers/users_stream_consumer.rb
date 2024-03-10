class UsersStreamConsumer < ApplicationConsumer
  include TasksApp::Import['users.create_user']

  def consume
    messages.each do |message|
      payload = message.payload.deep_symbolize_keys!
      validate_event!(payload)

      case [payload[:event], payload[:event_version]]
      in 'UserCreated', 1
        create_user.(payload[:data][:user]).value!
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

