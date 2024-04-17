class VolunteersController < ApplicationController
  before_action :authenticate_user, only: :create

  def create
    # @volunteer = Volunteer.find(params[:volunteer_id])
    # @v_contribution = @volunteer.volunteer_contributions.find_or_initialize_by(user_id: params[:user_id])
    # if @v_contribution.save
    #   render json: {message: "Thanks for the contribution!", status: :ok }
    # else
    #   render json: {message:  @v_contribution.errors.full_messages, status: 404}
    # end
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
  def get_Escrow_amount(wallet_address)
    url = URI("#{$smart_contract_server_url}/v2/get_volunteer_balance/#{wallet_address}")
    http = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    response
  end

  def get_volunteer
    @volunteer = Volunteer.find(params[:id])
    render :json => @volunteer 
  end

  private
  def volunteer_params
    params.require(:volunteer).permit(:user_id, :volunteer_id)
  end
end