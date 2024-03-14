class MostExpensiveTaskTransaction < BaseTransaction
  request_schema do
    hash_schema(
      token: string,
      from: iso8601,
      to: iso8601
    )
  end

  map  :unwrap
  step :typecast
  step :validate_ststion_token, with: 'users.retrieve_user'
  step :authorize
  step :perform

  def authorize(input)
    user = input[:user]

    if user.role.in?(%w[admin])
      Success(input)
    else
      Failure(:not_found)
    end
  end

  def perform(input)
    input in from:, to:

    tasks = Task.where(created_at: from..to)

    most_expensive_task_price = tasks.maximum(:reward)

    Success(from:, to:, price: most_expensive_task_price)
  end
end
