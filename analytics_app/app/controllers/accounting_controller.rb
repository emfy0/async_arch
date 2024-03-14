class AccountingController < AnalyticsController
  def me
    render_response(
      MeTransaction.new, params_with_session
    ) { |r| render json: r }
  end

  def top_management_profit
    render_response(
      TopManagementProfitTransaction.new, params_with_session
    ) { |r| render json: r }
  end
end
