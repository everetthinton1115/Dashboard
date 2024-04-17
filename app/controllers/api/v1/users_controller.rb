class Api::V1::UsersController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user, only: %i[unread_messages index tasks index user_detail update_user open_ai_images]
  skip_before_action :verify_authenticity_token

  def index
    if params[:search].present?
      @users = User.where('name ILIKE ?', "%#{params[:search]}%")
    elsif current_user.is_volunteer?(current_user)
      @users = User.where(id: Campaign.where(id: VolunteerApplier.where(user_id: current_user.id, status: 'approved').pluck(:campaign_id)).pluck(:user_id))
    else
      # send all users just for testing purpose
      # @users = User.all
      @users = User.where(id: VolunteerApplier.where(campaign_id: current_user.campaigns.ids, status: 'approved').pluck(:user_id)).all_except(current_user)
    end
  end

  def user_detail
    @user = current_user
  end

  def forget_password
    begin
      @user = User.find_by(email: params[:email])
      if @user.present?
        @user.update!(confirmation_token: SecureRandom.hex(10))
        token = @user.confirmation_token
        ApplicationMailer.forget_password(@user, token).deliver_now
        message = "We have send you recover password email, Please check your email if you not get any email check your spam folder"
        render json: { success: true, message: message }
      else
        render json: { success: false, message: "Please enter valid email" }
      end
    rescue => e
      render json: { success: false, message: e.message }
    end
  end

  def update_user
    begin
      @user = current_user
      if params[:password].present?
        if params[:password] == params[:password_confirmation]
          @user.password = params[:password]
          @user.password_confirmation = params[:password_confirmation]
        else
          render json: { success: false, message: "Password not match with Password Confirmation" }
          return
        end
      end

      if params[:wallet_address].present? && @user.wallet_address == ''
        @user.update!(user_update_params_with_wallet_address)
        # begin
        #   InviteMailer.new_wallet_address(current_user).deliver_now
        # rescue => e
        #   puts "EMAIL ERROR LOGS : #{e.message}"
        # end
      else
        @user.update!(user_update_params)
      end
    rescue => e
      render json: { success: false, message: e.message }
    end
  end

  def update_password
    begin
      @user = User.find_by!(confirmation_token: params[:token])
      if params[:password].present? && params[:password] == params[:password_confirmation]
        @user.update!(password: params[:password], password_confirmation: params[:password_confirmation])
        render json: { success: true, message: "Password successfully updated" }
      else
        render json: { success: true, message: "Password not match with Password Confirmation" }
      end
    rescue => e
      render json: { success: false, message: e.message }
    end
  end

  def all_users_emails
    @users = User.all
    render :all_users_emails
  end

  def tasks
    @tasks = Volunteer.where(id: current_user.volunteer_appliers.pluck(:volunteer_id))
    # render json: tasks
  end

  def unread_messages
    user_chatrooms = current_user.chatrooms.ids
    unread_messages = Message.where(chatroom_id: user_chatrooms).received_by(current_user).unread_by(current_user).count
    render json: {success: true, unread_messages: unread_messages }
    end

  def open_ai_images
    if params[:image]
      url = URI("https://api.openai.com/v1/images/variations")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request["Authorization"] = ""
      form_data = [['image', params[:image]], ['n', '4'], ['size', '512x512']]
      request.set_form form_data, 'multipart/form-data'
      response = JSON(https.request(request).body)
      if response['error']
        render json: { success: false, message: response['error']['message'] }
      else
        current_user.update(limit: (current_user.limit - 1))
        render json: { success: true, data: response['data'] }
      end
    else
      render json: { success: false, message: "Missing Image Parameter." }
    end

  end

  def update_database
    begin
      if params[:id]
        nft = Nft.where(id: params[:id].to_i).first
        if nft
          nft.update(nft_status: "approved", tx_id: params[:transactionHash])
          render json: { success: true, message: 'Nft created successfully.' }
        else
          render json: { success: false, message: 'NFT not found' }
        end
      else
        # @nft = Nft.all.where(nft_status: ['Created', 'Purchased'])
        # @nft = current_user.nfts.where(nft_status: ['Created', 'Purchased'])
        @nft = current_user.nfts
      end
    rescue => e
      render json: { success: false, message: e.message }
    end
  end

  private
  def user_update_params
    params.permit(:name, :email, :address_line1, :address_line2, :address_city, :profile,
                                 :address_state, :address_country, :address_zip, :identification_photo,
                  :password, :password_confirmation, :limit, :facebook_url, :linkedin_url, :website_url)

  end

  def user_update_params_with_wallet_address
    params.permit(:name, :email, :address_line1, :address_line2, :address_city, :profile,
                  :address_state, :address_country, :address_zip, :identification_photo,
                  :wallet_address, :password, :password_confirmation, :limit, :facebook_url, :linkedin_url, :website_url)

  end
end