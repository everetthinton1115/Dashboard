require "uri"
require "net/http"

class RegistrationsController < Devise::RegistrationsController
  def new
    @role = Role.where(name: 'charity_coordinator')
    @coordinators_list = UserRole.where(role_id: @role[0].id)
    @coordinators = []
    @coordinators_list.each do |c|
      @coordinators << { id: c.user_id, name: c.user.name } if c.user.present?
    end
    @coordinators.to_json
    super
  end

  def create
    # Get roll from param
    role = case params[:user][:member_type]
           when 'charity' then Role.charity_admin
           when 'vendor' then Role.vendor
           when 'donor' then Role.donor
           when 'charity_coordinator' then Role.charity_coordinator
           when 'nft' then Role.nft
           else Role.member
           end

    # We need to make sure only charities are creating alliances
    if role == Role.charity_admin
      build_resource(sign_up_params)
    else
      build_resource(sign_up_params.except(:alliance_attributes))
    end

    yield resource if block_given?

    # label to generate address at API end - same label for all accounts of user
    user_label_for_addresses = SecureRandom.alphanumeric(20)
    # blockio = BlockioApiService.block_io
    # begin
    #   blockio.get_new_address :label => user_label_for_addresses
    #   btc_address = (blockio.get_address_by_label :label => user_label_for_addresses)['data']['address'] || nil
    # rescue BlockIo::APIException => e
    #   e.raw_data
    # rescue Exception => e
    #   flash[:error] = e
    # end

    # Create ethereum address for the user
    # eth_response = Faraday.post("#{ENV['CRYPTO_WALLET_API_V2']}/ethereum/mainnet/addresses") do |req|
    #     req.headers['Content-Type'] = 'application/json'
    #     req["X-API-Key"] = "#{ENV['MY_CRYPTO_APIS_KEY']}"
    #     req.body = {
    #         data: {
    #             item: {
    #                 label: user_label_for_addresses
    #             }
    #         }
    #     }.to_json
    # end
    # eth_address = JSON.parse(eth_response.body)['data']['item']['address'] || nil
    # good_address = eth_address

    # Check the registration response if bad then we start over
    # unless eth_response.success? && eth_response.status == 200
    #     puts 'ERROR CREATING WALLET: ', eth_response.body
    #     Rails.logger.error "Error Registering User Wallet API: #{eth_response.body}"
    #     clean_up_passwords resource
    #     set_minimum_password_length
    #     flash[:error] = 'Error Registering. If this continues please contact our Support Team.'
    #     render :new
    #     return
    # end

    # Get ethereum address details
    # eth_login_response = Faraday.get("#{ENV['CRYPTO_REST_API_V2']}/blockchain-data/ethereum/mainnet/addresses/#{eth_address}") do |req|
    #     req.headers['Content-Type'] = 'application/json'
    #     req["X-API-Key"] = "#{ENV['MY_CRYPTO_APIS_KEY']}"
    # end

    # # Check the registration response if bad then we start over
    # unless eth_login_response.success?
    #     puts 'Error Logging into User Wallet API: ', resource[:email], eth_login_response.body
    #     Rails.logger.error "Error Logging into User Wallet API: #{resource[:email]}, #{eth_login_response.body}"
    #     clean_up_passwords resource
    #     set_minimum_password_length
    #     flash[:error] = 'Error Registering. If this continues please contact our Support Team.'
    #     render :new
    #     return
    # end

    # resource.bitcoin_address = btc_address
    # resource.ethereum_address = eth_address
    # resource.commit_good_address = good_address

    # Set user wallet password for later
    # save address label
    # resource[:wallet_password] = EncryptionService.encrypt(user_label_for_addresses)
    resource.authorization_token = user_label_for_addresses
    get_lat_lng_positions
    resource.save!

    # if params[:user][:charity_id].present?
    #   add_coordinator_with_charity
    # end
    if resource.persisted?
      # Create subscription event to allow crytoAPI to send callbacks for ethereum
      # subscription_api ="#{ENV['CRYPTO_REST_API_V2']}/blockchain-events/ethereum/mainnet/subscriptions/address-coins-transactions-unconfirmed"
      # Faraday.post(subscription_api) do |req|
      #     req.headers['Content-Type'] = 'application/json'.freeze
      #     req['X-API-Key'] = (ENV['MY_CRYPTO_APIS_KEY']).to_s
      #     req.body = {
      #       data: {
      #         item: {
      #           address: resource.ethereum_address,
      #           allowDuplicates: true,
      #           callbackSecretKey: "testCallback2",
      #           callbackUrl: "#{ENV['CRYPTO_APIS_CALLBACK_URL']}/transaction_callback"
      #         }
      #       }
      #     }.to_json
      # end
      resource.roles << role
      # if resource.active_for_authentication?
      #   set_flash_message! :notice, :signed_up
      #   sign_up(resource_name, resource)
      #   respond_with resource, location: after_sign_up_path_for(resource)
      # else
      send_email_confirmation

      # if @mail_status
      flash[:success] = 'Successfully registered please confirm your account through email'
      # else
      #   flash[:info] = "Please enter valid email address"
      # end
      # ApplicationMailer.confirmation_mail resource
      # set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
      expire_data_after_sign_in!
      respond_with resource, location: sign_in_path
      # end
    else
      clean_up_passwords resource
      set_minimum_password_length
      flash[:error] = 'Error Registering. If this continues please contact our Support Team.'
      render :new
    end
  end

  def confirm_user
    @user = User.where(confirm_token: params[:token]).first
    if !@user.email_confirmed && !@user.confirmed_at
      @user.update_attributes(email_confirmed: true, confirmed_at: DateTime.now)
      flash[:success] = 'Successfully Confirmed, You can login now'
    else
      flash[:error] = 'This Email is already verified'
    end
    redirect_to sign_in_path
    # else
    #   flash[:info] = "Please enter valid email address"
    # end
    # ApplicationMailer.confirmation_mail resource
    # set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
    # expire_data_after_sign_in!
    # respond_with resource, location: new_user_session_path
  end

  def states
    states = CS.states(params[:country_code])
    required_state = params[:state_code].present? ? params[:state_code].to_sym : states.first[0]
    cities = states.present? ? CS.cities(required_state, params[:country_code]) : {}
    render json: { states: states, cities: cities }, status: :ok
  end

  def cities
    cities = CS.cities(params[:state_code], params[:country_code])
    render json: { cities: cities }, status: :ok
  end

  def charities_list
    @user_roles = UserRole.where(role_id: 2)
    @charities_list = []
    @user_roles.each do |role|
      next unless role.user.present?
      # puts role.user.name
      @charities_list << { name: role.user.name, id: role.user.id }
    end
    render json: @charities_list, status: 200
  end

  def area_of_interest
    areas = case params[:interest_type]
            when 'charity' then AreaOfInterest.for_charities
            when 'vendor' then AreaOfInterest.for_vendors
            else
              AreaOfInterest.all
            end
    data = areas.collect { |x| { id: x.id, name: x.name } }
    render json: {
      success: true,
      data: data
    }, status: :ok
  end

  def project_coordinators
    @role = Role.where(name: 'charity_coordinator')
    @coordinators_list = UserRole.where(role_id: @role[0].id).includes([:user])
    @coordinators = []
    @coordinators_list.each do |c|
      @coordinators << { id: c.user_id, name: c.user.name } if c.user.present? && c.user.wallet_address.present?
    end
    @coordinators
    render json: {
      success: true,
      data: @coordinators
    }, status: :ok
  end

  def all_emails
    emails = User.select(:email).map(&:email)
    render json: emails, status: :ok
  end

  def check_wallet
    if params[:wallet_address].present?
      wallet = User.find_by_wallet_address(params[:wallet_address])
      if wallet
        render json:{
          success: true,
          message: "Wallet found"
          }
      else
        render json:{
          success: false,
          message: "Not Found"
        }
      end
    else
      render json:{
        success: false,
        message: "Please provide a valid wallet address."
        }
    end
  end
  
  

  def tasks
      token = request.headers["token"] rescue nil
      current_user = User.find_by(token: token) if token.present?
      return render json: {
        success: false,
        message: "Unauthorized request. You need to log in again."
      }, status: 401 unless current_user

      @tasks = Volunteer.where(id: current_user.volunteer_appliers.where(status: "approved").pluck(:volunteer_id))
  end

  def request_activation_email
    email = "#{params[:email]}.#{params[:format]}"
    random_string = SecureRandom.hex
    user = User.where(email: email).first
    if user.present?
      user.update_attributes(confirm_token: random_string)
      ApplicationMailer.confirmation_mail(user).deliver_now
      flash[:success] = 'Confirmation email successfully sent to your email, please check your email'
    else
      flash[:error] = 'User not found with this email'
    end
    redirect_back(fallback_location: request.referer)
  end

  def access_token
    begin
      url = URI("https://api.global.id/v1/auth/token")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/x-www-form-urlencoded"
      # code = "G1Byw6HhsaSQZpxAukAtoRWWdLIaOCvCYkt2Dt23xZI.hGACYVpHP6U7KQTaCFkI4JWLsGiEat4xura7_6pOkN4"
      code = params[:code]
      client_id = params[:client_id]
      client_secret = params[:client_secret]
      redirect_uri = params[:redirect_uri]
      request.body = "grant_type=authorization_code&client_id=#{client_id}&client_secret=#{client_secret}&redirect_uri=#{redirect_uri}&code=#{code}"
      response = https.request(request)
      unless JSON.parse(response.body)["statusCode"].eql?(400)
        puts "@@#{JSON.parse(response.body).inspect}"
        Rails.logger.info "@@#{JSON.parse(response.body).inspect}"

        url = URI("https://api.global.id/v1/identities/me")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = Net::HTTP::Get.new(url)
        access_token = JSON.parse(response.body)["access_token"]
        request["Authorization"] = "Bearer #{access_token}"
        response = https.request(request)
        if response.code.eql?("200")
          puts "@@#{JSON.parse(response.body).inspect}"
          Rails.logger.info "@@#{JSON.parse(response.body).inspect}"

          gid_uuid = JSON.parse(response.body)["gid_uuid"]
          puts "@@#{gid_uuid}"
          Rails.logger.info "@@#{gid_uuid}"
          @user = User.find_by_uuid(gid_uuid)

          puts "@@#{@user.inspect}"
          Rails.logger.info "@@#{@user.inspect}"

          unless @user.token.present?
            access_token = @user.generate_access_token
            @user.update(token: access_token.token)
          end
          if @user
            return render json: {
              access_token: @user.token,
              logged_in: true,
              user: UserSerializer.new(@user, include: [], scope_name: 'current_user')
            }
          else
            return render json: {
              success: true,
              data: JSON.parse(response.body)
            }
          end

        else
          puts "@@#{JSON.parse(response.body)["message"].inspect}"
          Rails.logger.info "@@#{JSON.parse(response.body)["message"].inspect}"
          render json: {
            success: false,
            data: JSON.parse(response.body)["message"]
          }
        end
      else
        puts "@@#{JSON.parse(response.body)["message"].inspect}"
        Rails.logger.info "@@#{JSON.parse(response.body)["message"].inspect}"
        render json: {
          success: false,
          data: JSON.parse(response.body)["message"]
        }
      end
    rescue => e
      puts "@@#{JSON.parse(response.body)["message"].inspect}"
      Rails.logger.info "@@#{JSON.parse(response.body)["message"].inspect}"
      render json: {
        success: false,
        data: e.message
      }
    end
  end

  def verify_account
    begin
      user = User.find_by_wallet_address(params[:wallet_address])
      if user
        puts "@@#{user.wallet_address_verified.eql? true}"
        Rails.logger.info "@@#{user.wallet_address_verified.eql? true}"
        if user.wallet_address_verified.eql? true
          render json: {
            success: true,
            message: "Account Updated Successfully."
          }
        else
          user.update(wallet_address_verified: true)
          begin
            puts "@@Sending Email"
            Rails.logger.info "@@Sending Email"
            InviteMailer.wallet_address_added(user).deliver_now
          rescue => e
            puts "EMAIL ERROR LOGS : #{e.message}"
          end
          render json: {
            success: true,
            message: "Account Updated Successfully."
          }
        end

      else
        render json: {
          success: false,
          message: "Invalid Wallet Address."
        }
      end
    rescue => e
      render json: {
        success: false,
        message: e.message
      }
    end
  end

  protected

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
      :profile,
      :identification_photo,
      :license_photo,
      :terms_accepted,
      alliance_attributes: [:name, :contact_email, :description, :logo, :area_of_interest_id,
                            :website_url, :facebook_url, :twitter_url, :gplus_url, :verification_doc, :region_id, :campaign_coordinator_id,
                            { locations_attributes: %i[address_line1 address_line2 address_city address_state
                                                             address_zip] }],
      area_of_interest_ids: [],
      license_photo: [],
      identification_photo: []
    )
  end

  # def add_coordinator_with_charity
  #   @connection = CharitiesCoordinator.new(charitable_id: params[:user][:charity_id], charitable_type: "User", user_id: resource.id)
  #   @connection.save
  # end
  def send_email_confirmation
    random_string = SecureRandom.hex
    resource.update_attributes(confirm_token: random_string)
    ApplicationMailer.confirmation_mail(resource).deliver_now
  end

  def get_lat_lng_positions
    # lat = Geocoder.search(CS.cities(params[:user][:address_state], params[:user][:address_country])[(params[:user][:address_city]).to_i])
    lat = Geocoder.search(CS.cities("PB", "PK")[(99).to_i])
    @coords = lat.first.coordinates

    puts 'COOOORDINATES:::::::', @coords
    resource.update_attributes(lat: @coords[0], lng: @coords[1])
  end
end