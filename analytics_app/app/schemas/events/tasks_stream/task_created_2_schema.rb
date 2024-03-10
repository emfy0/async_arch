module Events
  module TasksStream
    class TaskCreated2Schema < BaseEventSchema
      event_schema do
        hash_schema(
          data: {
            task: {
              public_id: string,
              name: string,
              jira_id: string,
              description: string,
              user: { public_id: string }
            }
          }
        )
      end
    end
  end
end
