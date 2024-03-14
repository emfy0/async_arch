module Events
  module UsersStream
    class UserCreated1Schema < BaseEventSchema
      event_schema do
        hash_schema(
          data: {
            user: {
              username: string,
              role: included_in(['admin', 'user', 'manager']),
              public_id: string
            }
          }
        )
      end
    end
  end
end
