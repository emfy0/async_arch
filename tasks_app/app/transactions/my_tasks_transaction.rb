class MyTasksTransaction < BaseTransaction
  request_schema do
    hash_schema(
      token: string
    )
  end

  map  :unwrap
  step :typecast
  step :validate_ststion_token, with: 'users.retrieve_user'
  step :find_task

  def find_task(input)
    input in user:

    Success(user:, tasks: user.tasks.to_a)
  end
end
