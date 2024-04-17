class Api::Users::RegistrationsController < Api::BaseController
  skip_before_action :doorkeeper_authorize!, only: %I[create]
  protect_from_forgery with: :null_session

  def create
    begin
      puts "USING API REGISTRATION???????"
      if params[:user][:uuid].nil? || User.find_by(uuid: params[:user][:uuid]).nil?
        @user = User.new(sign_up_params)
        access_token = @user.generate_access_token
        @user.token = access_token.token
        if @user.valid?
          unless params[:alliance][0][:campaign_coordinator_id].empty?
            @user.update(alliance_id: params[:alliance][0][:campaign_coordinator_id].to_i)
          end
          role = case params[:user][:member_type]
                 when "charity_admin" then Role.charity_admin
                 when "vendor" then Role.vendor
                 when "volunteer" then Role.volunteer
                 when "charity_coordinator" then Role.charity_coordinator
                 when "donor" then Role.donor
                 when "nft" then Role.nft
                 else Role.member
                 end
          @user.roles << role
          if params[:user][:member_type] == "nft"
            begin
              puts "&&&&&&&&&&&&&&&&&&&&&&&&&&START SENDING THE REQUEST"
              Rails.logger.info "&&&&&&&&&&&&&&&&&&&&&&&&&&START SENDING THE REQUEST"
              url = URI("http://localhost:3002/v2/update_role/#{params[:user][:wallet_address]}")
              http = Net::HTTP.new(url.host, url.port);
              request = Net::HTTP::Get.new(url)
              response = http.request(request)
              Rails.logger.info "response : #{JSON[response.body]}"
              if JSON[response.body]['success'] == false
                if JSON(response.body)['error']['reason']
                  return render_error_response(JSON(response.body)['error']['reason'])
                else
                  return render_error_response(JSON(response.body)['error'][0..150] + ".....")
                end

              end
              puts "response : #{response}"
              Rails.logger.info "response : #{response}"
            rescue => e
              puts "######################################### #{e.message}"
              Rails.logger.info "######################################### #{e.message}"
            end
          end
          @user.save!
          InviteMailer.registration(@user).deliver_later
          render json: {
            access_token: @user.token,
            user: UserSerializer.new(@user, include: [], scope_name: 'current_user')
          }
        else
          render_error_response(@user.errors.full_messages.to_sentence)
        end
        # render_error_response(access_token)
      else
        render_error_response("User already exist.")
      end
    rescue => e
      render_error_response(e.message)
    end
  end

  def tasks
    @tasks = Volunteer.where(id: current_user.volunteer_appliers.where(status: "approved").pluck(:volunteer_id))
  end

  private

  def sign_up_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :name,
      :referral_code,
      :member_type,
      :address_line1,
      :address_line2,
      :address_city,
      :address_state,
      :address_country,
      :address_zip,
      :terms_accepted,
      :uuid,
      :provider,
      :wallet_address,
      :profile,
      alliance_attributes: [:name, :contact_email, :description, :logo, :area_of_interest_id,
                            :website_url, :facebook_url, :twitter_url, :gplus_url, :verification_doc, :region_id]
    )
  end

end
