class Api::V1::CampaignCheckInHistoriesController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user

  def create
    begin
      CampaignCheckInHistory.where(user_id: current_user.id).update_all(redeem_at: DateTime.now)
      render json: { success: true, message: "Redeem Successfully" }
    rescue => e
      render json: { success: false, message: e.message }
    end
  end
end