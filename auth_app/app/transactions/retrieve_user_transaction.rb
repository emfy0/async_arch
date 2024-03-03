class RetrieveUserTransaction < BaseTransaction
  request_schema do
    hash_schema(
      token: string,
    )
  end

  map  :unwrap
  step :typecast
  step :find_user

  def find_user(input)
    input in token:

    session = Session.find_by(token:)

    if session&.active?
      Success(input.merge!(user: session.user))
    else
      Failure('invalid token')
    end
  end
end
