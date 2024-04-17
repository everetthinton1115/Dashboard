class Api::V1::VolunteersController < ApplicationController
  before_action :authenticate_user
  before_action :set_volunteer, only: %i[update]
  def create
    wallet_address = current_user.wallet_address
    if wallet_address
      hours = CampaignCheckInHistory.where(user_id: current_user.id, redeem_at: nil).pluck(:total_hours).sum(&:to_i)
      if hours > 0
        url = URI("#{$smart_contract_server_url}/v2/update_volunteer_account?wallet_address=#{wallet_address}&hours=#{hours}")
        http = Net::HTTP.new(url.host, url.port);
        request = Net::HTTP::Get.new(url)
        http.request(request)
        if JSON.parse(response.body)['success']
          CampaignCheckInHistory.where(user_id: current_user.id).update_all(redeem_at: DateTime.now)
          render json: {
            success: true,
            result: "Volunteer allowance send to Escrow successfully."
          }
        else
          render json: {
            success: false,
            message: JSON.parse(response.body)['error']
          }
        end
      else
        render json: {
          success: false,
          message: 'Hours less than 1 can not be withdrawn.'
        }
      end

    else
      render json: {
        success: false,
        message: "Wallet address not found. Please add you wallet address from your profile section."
      }
    end
  end

  def show
    wallet_address = current_user.wallet_address.present? ? current_user.wallet_address : params[:id]
    if wallet_address.present?
      response = get_Escrow_amount(wallet_address)
      if JSON.parse(response.body)['success']
        hours = CampaignCheckInHistory.where(user_id: current_user.id, redeem_at: nil).pluck(:total_hours).sum(&:to_f)
        render json: {
          success: true,
          escrow_amount: JSON.parse(response.body)['amount'],
          tracked_time: hours.to_s + " Hours"
        }
      else
        render json: {
          success: false,
          message: JSON.parse(response.body)['error']
        }
      end
    else
      render json: {
        success: false,
        message: "Wallet address not found. Please add you wallet address from your profile section."
      }
    end
  end

  def get_Escrow_amount(wallet_address)
    url = URI("#{$smart_contract_server_url}/v2/get_volunteer_balance/#{wallet_address}")
    http = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    response
  end

  def update
    begin
      @volunteer.update!(volunteer_params)
      render json: {
        success: true,
        message: "Volunteer updated successfully."
      }
    rescue => e
      render json: {
        success: false,
        message: e.message
      }
    end
  end

  private

  def set_volunteer
    begin
      @volunteer = Volunteer.find(params[:id].to_i)
    rescue => e
      render json: { success: false, message: e.message }
    end
  end

  def volunteer_params
    params.permit(:title, :description, :hours, :number)
  end
end