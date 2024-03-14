module Events
  module TasksLifecycle
    class TaskAssigned1Schema < BaseEventSchema
      event_schema do
        hash_schema(
          data: {
            task: {
              public_id: string,
              user: { public_id: string }
            }
          }
        )
      end
    end
  end
end
