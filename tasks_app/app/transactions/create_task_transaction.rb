class CreateTaskTransaction < BaseTransaction
  request_schema do
    task = hash_schema(
      name: string,
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
      **input[:task_params]
    )

    Success(input.merge!(task:))
  end

  def broadcast(input)
    BaseProducer.(:tasks_stream, :task_assigned, task: input[:task])
  end
end
