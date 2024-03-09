respond_with_success(json, nil) do
  json.user do
    json.partial! 'users/user', user: @user
  end
end
