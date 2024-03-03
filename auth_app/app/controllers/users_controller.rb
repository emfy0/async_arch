class UsersController < ApplicationController
  def register
    render_response(
      CreateUserTranasction.new, params
    ) { |r| @token = r[:token] }
  end

  def retrieve_current
    render_response(
      RetrieveUserTransaction.new, params_with_session
    ) { |r| @user = r[:user] }
  end
end
