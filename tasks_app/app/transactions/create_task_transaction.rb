class CreateTaskTransaction < BaseTransaction
  request_schema do
    task = hash_schema(
      name: string & check { _1[/\[\S+\]/].nil? },
      jira_id: string,
      description: string
    )

    hash_schema(
      token: string,
      task: 
    )
  end

  remap_schema(
    task_params: :task
  )

  map  :unwrap
  step :typecast
  step :validate_ststion_token, with: 'users.retrieve_user'
  step :create_task
  tee  :broadcast

  def create_task(input)
    task = Task.create!(
      user: User.non_management.random.first,
      public_id: SecureRandom.uuid,
      **input[:task_params]
    )

    Success(input.merge!(task:))
  end

  def broadcast(input)
    task = input[:task]

    BaseProducer.(:tasks_stream, :TaskCreated, 2, task:)
    BaseProducer.(:tasks_lifecycle, :TaskAssigned, 1, task:)
  end
end
