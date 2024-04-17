class Api::V1::CampaignsController < ApplicationController
  before_action :authenticate_user, only: %i[new create user_campaigns
                                             user_accepted_campaigns coordinator_campaigns show volunteer_applier_paid
                                              volunteer_applier]
  before_action :set_campaign, only: %i[show edit update destroy]

  def index
    if current_user && current_user.roles.first.try(:name).eql?("charity_coordinator")
      @scope = Campaign.where(campaign_coordinator_id: current_user.id).includes(:volunteers, :images).paginate(page: params[:page], per_page: 8)
      fillter_campaigns
    else
      @scope = Campaign.includes(:volunteers, :images).paginate(page: params[:page], per_page: 8)
      fillter_campaigns
    end
  end

  def user_campaigns
    # @scope = current_user.campaigns.paginate(page: params[:page], per_page: 6)
    @scope = current_user.campaigns.paginate(page: params[:page], per_page: 12)
    fillter_campaigns
    render 'api/v1/campaigns/index'
  end

  def wallet_address
    begin
      @campaign = Campaign.find(params[:id])
      @campaign_coordinator_wallet_address = @campaign.campaign_coordinator_id.present? ? User.find(@campaign.campaign_coordinator_id).wallet_address : ""
    rescue => e
      render json: { success: false, message: e.message }
    end
  end

  def volunteer_applier_paid
    begin
      @volunteer_applier = VolunteerApplier.where(campaign_id: params[:campaign_id], volunteer_id: params[:volunteer_id], status: "approved").first
      if @volunteer_applier.present?
        @volunteer_applier.update!(paid: true)
        render json: { success: true }
      else
        render json: { success: false, message: "record not found" }
      end
    rescue => e
      render json: { success: false, message: e.message }
    end
  end

  def new
    if current_user.roles.map(&:name).include? "charity_admin"
      # Find your charity to use its coordinator
      @charity = Alliance.where(id: current_user[:alliance_id]).first!

      @campaign = current_user.campaigns.new
      @campaign.volunteers.new
      @campaign.needs.new
      @campaign.region_id = current_user.region_id
      @campaign.campaign_coordinator_id = @charity[:campaign_coordinator_id]
      # @role = Role.where(name: 'charity_coordinator')
      # @coordinators_list = UserRole.where(role_id: @role[0].id)
      # @list = []
      # @coordinators_list.each do |c|
      #     @list << { id: c.user_id, name: c.user.name } if c.user.present?
      # end
      # @list.to_json
    else
      redirect_to campaigns_path
    end
  end

  def coordinator_campaigns
    @coordinator_campaigns = []
    if current_user
      @charities = CampaignCoordinator.where(user_id: current_user.id)
      @charities.each do |charity|
        @coordinator_campaigns << charity.campaign
      end
    end
  end

  def create
    begin
      @campaign = current_user.campaigns.new(campaign_params)
      @campaign.campaign_coordinator_id = current_user.try(:alliance_id)
      @campaign.save!
      if params[:images].present?
        params[:images].each do |image|
          @campaign.images.create(image: image)
        end
      end
      if params[:volunteers].present?
        params[:volunteers].each do |volunteer|
          Volunteer.create(title: volunteer[:title], description: volunteer[:description],
                            hours: volunteer[:hours], number: volunteer[:number],
                            campaign_id: @campaign.id)
        end
      end
      render json: {
        success: true,
        message: "Project created successfully."
      }
    rescue => e
      render json: {
        success: false,
        message: e.message
      }
    end

  end

  def user_accepted_campaigns
    @campaigns = current_user.volunteer_appliers.paginate(page: params[:page], per_page: 6)
    puts @campaigns.to_s
  end

  def accept_request
    begin
      @campaign_slug = params[:campaign_slug]
      @volunteer_slug = params[:apply_slug]
      @request = VolunteerApplier.friendly.find(@volunteer_slug)
      # @request = VolunteerApplier.where(campaign_id: params[:campain_id], user_id: params[:volunteer_id]).first
      if @request.status == 'pending'
        @request.update_attributes(status: 'approved')
        @campaign = Campaign.find(@campaign_slug.to_i)
        @volunteer = User.find(@request.user_id)
        VolunteerRequestMailer.campaign_accept_mailer(@campaign, @volunteer).deliver_now
      end
      redirect_to "https://staging.commitgood.com"
    rescue => e
      render json: {
        message: e.message
      }
    end
  end

  def show
    begin
      unless params[:id] == "open_api_images"
        @campaign = Campaign.find(params[:id])
      end
      if params[:campaign_voluteer]
        @volunteer_appliers = @campaign.volunteer_appliers.where(status: "approved")
        render :volunteer_appliers
      elsif params[:get_campaign]
        render :get_campaign
      elsif params[:id] == "open_api_images"
        if current_user.limit > 0
          response = fetch_images_from_openAI
          if response['error']
            render json: { success: false, message: response['error']['message'] }
          else
            current_user.update(limit: (current_user.limit - 1))
            render json: { success: true, data: response['data'] }
          end
        else
          render json: { success: false, message: 'Your free limit is expired. You need to purchase credits to continue.' }
        end

      else
        @campaign_volunteers = @campaign.volunteers

        # @campaign_coordinator = User.find_by_id(@campaign.campaign_coordinator_id)
        # @campaign_donation = @campaign.campaign_donations.new
        # @volunteers = @campaign.volunteers
        # @needs = @campaign.needs
        # # @bit_transaction_fee = Campaign.get_btc_fee_balance
        # # @eth_transaction_fee = Campaign.get_eth_transaction_fee
        # @messages = Message.where(sender_id: current_user.try(:id), receiver_id: @campaign.user_id).or(Message.where(sender_id: @campaign.user_id, receiver_id: current_user.try(:id)))
      end
    rescue => e
      render json: { success: false, message: e.message }
    end
  end

  def volunteer_applier
    @project = Volunteer.find(params[:volunteer_id])
    @campaign = Campaign.find(params[:campaign_id])
    @volunteer = current_user
    @volunteer_applier = VolunteerApplier.new(campaign_id: params[:campaign_id], user_id: current_user.id, volunteer_id: params[:volunteer_id], status: "pending", number_of_hours: params[:hours])
    @volunteer_applier.save
    puts "API KEY ======================?>     #{ENV["SENDGRID_API_KEY"]}"
    VolunteerRequestMailer.send_volunteer_request(@campaign, @volunteer, params[:campaign_id], params[:hours], @volunteer_applier.id, @project).deliver_now
  end

  def create_message
    @message = Message.create(sender_id: params[:sender_id], receiver_id: params[:receiver_id], text: params[:message])
  end

  def showing_wallet
    if current_user
      @bit_transaction_fee = Campaign.get_btc_fee_balance
      @eth_transaction_fee = Campaign.get_eth_fee_balance
      btc_address_wallet_response = Campaign.get_server_bitcoin_balance(current_user.bitcoin_address)
      eth_address_wallet_response = Campaign.get_server_ethereum_balance(current_user.ethereum_address)
      @btc_wallet = 0
      @eth_wallet = 0
      @good_wallet = 0
      if btc_address_wallet_response['status'] == 'success'
        balance = btc_address_wallet_response['data']['balances'][0]['available_balance']
        @btc_wallet = balance unless balance == "0.00000000"
      elsif btc_address_wallet_response.key?('error')
        flash[:error] = btc_address_wallet_response['error']
      end
      if eth_address_wallet_response.success?
        @eth_wallet = JSON.parse(eth_address_wallet_response.body)['data']['item']['confirmedBalance']['amount']
      end
      if current_user.charity_admin?
        @good_transactions = CampaignDonation.where(symbol: 'good').where("charity_id = ? or user_id = ?", current_user.id, current_user.id).order(id: :desc)
        @eth_transactions = CampaignDonation.where(symbol: 'eth').where("charity_id = ? or user_id = ?", current_user.id, current_user.id).order(id: :desc)
        @btc_transactions = CampaignDonation.where(symbol: 'btc').where("charity_id = ? or user_id = ?", current_user.id, current_user.id).order(id: :desc)

      elsif current_user.charity_coordinator?
        @good_transactions = CampaignDonation.where(symbol: 'good').where("campaign_coordinator_id = ? or user_id = ?", current_user.id, current_user.id).order(id: :desc)
        @eth_transactions = CampaignDonation.where(symbol: 'eth').where("campaign_coordinator_id = ? or user_id = ?", current_user.id, current_user.id).order(id: :desc)
        @btc_transactions = CampaignDonation.where(symbol: 'btc').where("campaign_coordinator_id = ? or user_id = ?", current_user.id, current_user.id).order(id: :desc)

      else
        @good_transactions = CampaignDonation.where(symbol: 'good', user_id: current_user.id).order(id: :desc)
        @eth_transactions = CampaignDonation.where(symbol: 'eth', user_id: current_user.id).order(id: :desc)
        @btc_transactions = CampaignDonation.where(symbol: 'btc', user_id: current_user.id).order(id: :desc)
      end
    else
      redirect_to sign_in_path
    end
  end

  def send_amount
    amount = 0
    if params[:symbol] == "good"
      amount = params[:token_amount]
      current_user_address = current_user.commit_good_address
    elsif params[:btc_amount]
      amount = params[:btc_amount]
      current_user_address = current_user.bitcoin_address
    else
      amount = params[:token_amount]
      current_user_address = current_user.ethereum_address
    end

    send_amount_response = CampaignDonation.send_transaction(current_user_address, params[:symbol], params[:wallet_address], amount)
    error_in_transaction = false
    error_in_transaction = true if (params[:symbol] == 'good' && JSON.parse(send_amount_response.body).key?('error')) || (params[:symbol] == 'btc' && send_amount_response.key?('error'))
    if error_in_transaction
      puts 'Error Send Transaction API: ', current_user.email, send_amount_response.body if params[:symbol] == 'good'
      Rails.logger.error "Error Send Transaction API: #{current_user.email}, #{send_amount_response.body}" if params[:symbol] == 'good'
      redirect_to showing_wallet_campaigns_path, notice: 'Error Transaction. If this continues please contact our Support Team.'
    else
      unless params[:symbol] == "btc"
        # create Donation and store ethereum transaction request id and its status
        txn_req = JSON.parse(send_amount_response.body)
        # to store transaction data of sending amount using addresses
        Donation.create!(request_id: txn_req['requestId'], donation_amount: txn_req['data']['item']['recipients'][0]['amount'], sender_address: txn_req['data']['item']['senders']['address'], receiver_address: txn_req['data']['item']['recipients'][0]['address'], transaction_request_id: txn_req['data']['item']['transactionRequestId'], transaction_request_status: "pending")
      end
      redirect_to showing_wallet_campaigns_path, notice: 'Send Amount successfully'
    end

  end

  def receive_amount
    amount = 0
    if params[:receive_symbol] == "good"
      amount = params[:receive_token_amount]
      current_user_address = current_user.commit_good_address
    elsif params[:receive_btc_amount]
      amount = params[:receive_btc_amount]
      current_user_address = current_user.bitcoin_address
    else
      amount = params[:receive_token_amount]
      current_user_address = current_user.ethereum_address
    end

    send_amount_response = CampaignDonation.send_transaction(params[:receive_wallet_address], params[:receive_symbol], current_user_address, amount)
    error_in_transaction = false
    error_in_transaction = true if (params[:receive_symbol] == 'good' && JSON.parse(send_amount_response.body).key?('error')) || (params[:receive_symbol] == 'btc' && send_amount_response.key?('error'))
    if error_in_transaction
      puts 'Error Send Transaction API: ', current_user.email, send_amount_response.body if params[:receive_symbol] == 'good'
      Rails.logger.error "Error Send Transaction API: #{current_user.email}, #{send_amount_response.body}" if params[:receive_symbol] == 'good'
      redirect_to showing_wallet_campaigns_path, notice: 'Error Transaction. If this continues please contact our Support Team.'
    else
      unless params[:receive_symbol] == "btc"
        # create Donation and store ethereum transaction request id and its status
        txn_req = JSON.parse(send_amount_response.body)
        # to store transaction data of sending amount using addresses
        Donation.create!(request_id: txn_req['requestId'], donation_amount: txn_req['data']['item']['recipients'][0]['amount'], sender_address: txn_req['data']['item']['senders']['address'], receiver_address: txn_req['data']['item']['recipients'][0]['address'], transaction_request_id: txn_req['data']['item']['transactionRequestId'], transaction_request_status: "pending")
      end
      redirect_to showing_wallet_campaigns_path, notice: 'Send Amount successfully'
    end
  end

  def edit
    # @role = Role.where(name: 'charity_coordinator')
    # @coordinators_list = UserRole.where(role_id: @role[0].id)
    # @list = []
    # @coordinators_list.each do |c|
    #     @list << { id: c.user_id, name: c.user.name } if c.user.present?
    # end
    # @list.to_json
  end

  def update
    begin
      @campaign.update!(campaign_edit_params)
      puts '!!!!!!!!!!!!!!!!!!!!!', params

      if params[:images].present?
        params[:images].each do |image|
          @campaign.images.create(image: image)
        end
      end

      if params[:old_images].present?
        @campaign.images.each do |c_image|
          delete = true
          params[:old_images].each do |o_image|


            Rails.logger.info "@@@@@@@@ #{c_image.image.url}"
            Rails.logger.info "@@@@@@@@ #{o_image["image_url"]}"
            Rails.logger.info "@@@@@@@@ #{c_image.image.url == o_image["image_url"]}"
            Rails.logger.info "@@@@@@@@ #{delete}"
            if c_image.image.url == o_image["image_url"]
              delete = false
              break
            end
          end
          Rails.logger.info "@@@@@@@@ #{delete}"
          if delete
            c_image.destroy
          end
        end
      end
      render json: {
        success: true,
        message: "Project Updated successfully."
      }
      # Check if you need to update existing images
      # update_existing_images = params[:update_images_attributes]
      # existing_images_array_of_ids = params[:images_attributes_existing].blank? ? [] : params[:images_attributes_existing]
      # unless update_existing_images.blank?
      #   if existing_images_array_of_ids.length != @campaign.images.length

      # Loop over each image and if we cannot find it in the array of existing then
      # delete them.. if you dont want this to happen dont include the update_images_attr param
      # @campaign.images.each do |image|
      #   unless existing_images_array_of_ids.include?(image[:id].to_s)
      #     image.destroy
      #   end
      # end
      # end
      # end

      # Check if you need to add new images
      # unless params[:images_attributes].nil?
      #   params[:images_attributes].each do |image|
      #     @campaign.images.create(image: image)
      #   end
      # end
      # redirect_to @campaign, notice: { success: 'Campaign successfully updated!' }
    rescue => e
      render json: {
        success: false,
        message: e.message
      }

    end
  end

  def get_need
    @need = Need.find(params[:id])
    render json: @need
  end

  def winner
    @campaign_winner = CampaignWinner.where(winnig_month: Time.now.beginning_of_month - 1.month)
  end

  def destroy
    @campaign.destroy
    render json: @campaign, status: :ok
  end

  # Method for the destroy the campaign media
  def destroy_campaign_media
    @image = Image.find(params[:id])
    @image.destroy
    render json: @image, status: :ok
  end

  def volunteer_interest
    @volunteer = UsersCampaign.new(user_id: current_user.id, campaign_id: params[:campaign_id], status: 'pending')
    @volunteer.save!
    @campain_user = Campaign.find(params[:campaign_id])
    VolunteerRequestMailer.send_volunteer_request(@campain_user, current_user, params[:campaign_id]).deliver_now
    render json: { data: { status: 200, info: @volunteer } }
  end

  def fetch_images_from_openAI
    url = URI("https://api.openai.com/v1/images/generations")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["Authorization"] = ""
    request["Content-Type"] = "application/json"
    request.body = JSON.dump({
                               "prompt": params[:text],
                               "n": 4,
                               "size": "1024x1024"
                             })
    JSON(https.request(request).body)
  end

  private

  def campaign_params
    params.permit(
      :name, :campaign_coordinator_id, :description, :goal_amount,
      :good_goal_amount, :region_id, :time_length, :address_city, :address_state,
      :address_country, :address_zip, :expiration_date

    )
  end

  def campaign_edit_params
    params.permit(
      :name, :description, :time_length, :expiration_date, :goal_amount,
      :good_goal_amount, :region_id, :address_city, :address_state,
      :address_country, :address_zip, :is_completed, :campaign_coordinator_id, images_attributes: [],
      images_attributes_existing: [], campaign_category_ids: [],
      volunteers_attributes: %i[
                id description title campaign_id hours number _destroy
            ]
    )
  end

  def fillter_campaigns
    @scope = @scope.where('campaigns.name ILIKE ?', "%#{params[:search]}%") if params[:search].present?
    if params[:campaign_category].present?
      @scope = @scope.joins(:campaign_categories).where(campaign_categories: { id: params[:campaign_category] }).distinct
    end
    @scope = @scope.where(address_country: params[:country]) if params[:country].present?
    @campaigns = @scope.order(created_at: :desc)
  end

  def set_coordinator
    @coordinator = CampaignCoordinator.new(campaign_id: @campaign.id, user_id: params[:campaign_coordinator_id])
    @coordinator.save
    @campaign.update_attributes(campaign_coordinator_id: @coordinator.id)
    # redirect_to campaign_path(@campaign)
  end

  def set_campaign
    begin
      unless params[:id] == "open_api_images"
        @campaign = Campaign.find(params[:id].to_i)
      end
    rescue => e
      render json: { success: false, message: e.message }
    end
  end
end
