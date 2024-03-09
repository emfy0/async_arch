class CreateUserTranasction < BaseTransaction
  request_schema do
    hash_schema(
      username: string,
      password: string,
      role: included_in(User::ROLES)
    )
  end

  map  :unwrap
  step :typecast
  within :db_transaction do
    step :create_user
    step :create_session
  end
  tee :broadcast

  def create_user(input)
    user = User.new(**input, public_id: SecureRandom.uuid)

    if user.save
      Success(input.merge!(user:))
    else
      Failure(user.errors)
    end
  end

  def create_session(input)
    session = Session.create!(
      user: input[:user],
      token: SecureRandom.uuid,
      valid_until: 1.day.from_now
    )

    Success(input.merge!(session:, token: session.token))
  end

  def broadcast(input)
    BaseProducer.(:users_stream, :UserCreated, 1, user: input[:user])
  end
end
