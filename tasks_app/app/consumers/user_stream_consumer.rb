class UserStreamConsumer < ApplicationConsumer
  include TasksApp::Import['users.create_user']

  def consume
    messages.each do |message|
      payload = message.payload.with_indifferent_access

      case payload[:event]
      when 'UserCreated'
        create_user.(payload['data']['user']).value!
      end
    end
  end
end

