class SessionsController < ApplicationController
  def create
    render_response(
      LoginUserTransaction.new, params
    ) { |r| @token = r[:token] }
  end
end

