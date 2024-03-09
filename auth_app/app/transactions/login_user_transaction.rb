class LoginUserTransaction < BaseTransaction
  request_schema do
    hash_schema(
      username: string,
      password: string
    )
  end

  map  :unwrap
  step :typecast
  step :find_user
  step :create_session

  def find_user(input)
    input in username:, password:

    user = User.find_by(username:)

    if user&.authenticate(password)
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
end

