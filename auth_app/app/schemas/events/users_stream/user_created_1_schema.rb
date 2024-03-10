module Events
  module UsersStream
    class UserCreated1Schema < BaseEventSchema
      event_schema do
        version_1 = hash_schema(
          data: {
            user: {
              username: string,
              role: included_in(['admin', 'user', 'manager']),
              public_id: string
            }
          }
        )

        switch(:event_version, compare(1) => version_1)
      end
    end
  end
end
