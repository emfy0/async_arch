class MeTransaction < BaseTransaction
  request_schema do
    hash_schema(
      token: string,
    )
  end

  map  :unwrap
  step :typecast
  step :validate_ststion_token, with: 'users.retrieve_user'
  step :perform

  def perform(input)
    user = input[:user]

    transactions = user.transactions
    balance = user.balance

    Success(transactions:, balance:)
  end
end

