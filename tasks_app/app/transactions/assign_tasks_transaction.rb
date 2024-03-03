class AssignTasksTransaction < BaseTransaction
  request_schema do
    hash_schema(
      token: string,
    )
  end

  map  :unwrap
  step :typecast
  step :validate_ststion_token, with: 'users.retrieve_user'
  step :authorize
  map :assign_tasks

  def authorize(input)
    user = input[:user]

    if user.role.in?(%w[admin manager])
      Success(input)
    else
      Failure(:unauthorized)
    end
  end

  def assign_tasks(input)
    Task.where(completed: false).find_each do |task|
      task.update!(user: User.non_management.random.first)
      BaseProducer.(:tasks_stream, :task_assigned, task:)
    end
  end
end

