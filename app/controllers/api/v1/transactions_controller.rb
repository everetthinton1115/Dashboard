class Api::V1::TransactionsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user

  def create
    begin
      if Campaign.find_by_id(params[:campaign_id])
        current_user.transactions.create!(transaction_params)
        render json: { success: true, message: "Transaction created successfully." }
      else
        render json: { success: false, message: "Campaign id does not exists." }
      end
    rescue => e
      render json: { success: false, message: e.message }
    end
  end

end

private

def transaction_params
  params.permit(:title, :tx_id, :amount_in_good, :amount_in_eth, :amount_in_usd, :campaign_id)
end