class AnalyticsController < ApplicationController
  def most_expensive_task
    render_response(
      MostExpensiveTaskTransaction.new, params_with_session
    ) { |r| render json: r, status: :ok }
  end
end
