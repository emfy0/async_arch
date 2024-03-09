module Users
  class CreateUser
    USER_PARAMS = %i[
      username
      role
      public_id
    ].freeze

    def call(params)
      Success(
        User.create!(params.slice(*USER_PARAMS))
      )
    end
  end
end
