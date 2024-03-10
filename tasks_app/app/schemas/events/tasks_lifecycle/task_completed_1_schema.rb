module Events
  module TasksLifecycle
    class TaskCompleted1Schema < BaseEventSchema
      event_schema do
        hash_schema(
          data: {
            task: {
              public_id: string,
            }
          }
        )
      end
    end
  end
end

