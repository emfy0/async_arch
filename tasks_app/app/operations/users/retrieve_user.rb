require "net/http"

module Users
  class RetrieveUser
    include TasksApp::Import["users.create_user"]

    BASE_URL = URI("http://puma_auth.async_external:3000").freeze

    def call(input)
      token = input[:token]
      response = Net::HTTP.get_response(BASE_URL + "/users/retrieve_current", "Authorization" => "Bearer #{token}")

      if response.code == "200"
        parsed_response = JSON.parse(response.body).with_indifferent_access

        user_params = parsed_response["user"]

        user = User.find_by(username: user_params["username"]) || create_user.(user_params).value!

        Success(input.merge!(user: user))
      else
        Failure(:unauthorized)
      end
    end
  end
end

