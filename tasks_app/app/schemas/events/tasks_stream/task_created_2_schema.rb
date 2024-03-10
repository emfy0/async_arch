module Events
  module TasksStream
    class TaskCreated1Schema < BaseEventSchema
      event_schema do
        hash_schema(
          data: {
            task: {
              public_id: string,
              name: string,
              description: string,
              user: { public_id: string }
            }
          }
        )
      end
    end
  end
end


