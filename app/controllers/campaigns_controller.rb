class CampaignsController < ApplicationController
    before_action :authenticate_user, only: %i[new create user_campaigns user_accepted_campaigns
                                               coordinator_campaigns update_status]
    before_action :set_campaign, only: %i[show edit update destroy update_status]

    def index
        if current_user && current_user.super_admin?
            redirect_to admin_root_path and return
        elsif current_user && current_user.charity_coordinator?
            @scope = Campaign.where(campaign_coordinator_id: current_user.id).paginate(page: params[:page], per_page: 8)
            fillter_campaigns  
        else
            @scope = Campaign.paginate(page: params[:page], per_page: 8)
            fillter_campaigns
        end

        respond_to do |format|
            format.js
            format.html
        end
    end

    def verify_domain
        respond_to do |format|
            format.text
        end
    end

    def transaction_callback
        event = params['data']['event'] || nil
        donation = Donation.find_by(transaction_request_id: params['referenceId'])
        if donation
            case event
            when "TRANSACTION_REQUEST_APPROVAL" then donation.update_attribute(:transaction_request_status, "approved")
            when "TRANSACTION_REQUEST_REJECTION" then donation.update_attribute(:transaction_request_status, "rejected")
            when "TRANSACTION_REQUEST_FAIL" then donation.update_attribute(:transaction_request_status, "failed")
            end
        end
        redirect_to root_path
    end

    def user_campaigns
        @scope = current_user.campaigns.paginate(page: params[:page], per_page: 6)
        fillter_campaigns

        respond_to do |format|
            format.js
            format.html
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
        @campaign = current_user.campaigns.new(campaign_params)
        authorize @campaign
        if @campaign.save!
            if params[:images_attributes]
                params[:images_attributes].each do |image|
                    @campaign.images.create(image: image)
                end
            end
            @message_hash = {
                charity: @campaign.user.wallet.try(:meta_address),
                charityId: @campaign.user_id,
                campaignId: @campaign.id,
                goal: @campaign.goal_amount
            }
            # set_coordinator
            redirect_to user_campaigns_campaigns_path
        else
            flash[:error] = 'Error submitting your project; please review and resubmit. Sorry.'
            render :new
        end
    end

    def user_accepted_campaigns
        @campaigns = current_user.volunteer_appliers.paginate(page: params[:page], per_page: 6)
        puts @campaigns.to_s
    end

    def accept_request
        @campaign_id = params[:campain_id]
        @volunteer_id = params[:volunteer_id]
        @request = VolunteerApplier.find(@volunteer_id)

        # @request = VolunteerApplier.where(campaign_id: params[:campain_id], user_id: params[:volunteer_id]).first
        if @request.status == 'pending'
            @request.update_attributes(status: 'approved')
            @campaign = Campaign.find(@campaign_id)
            @volunteer = User.find(@request.user_id)
            VolunteerRequestMailer.campaign_accept_mailer(@campaign, @volunteer).deliver_now
        else
            puts 'already accepted'
        end
        redirect_to user_campaigns_campaigns_path
    end

    def show
		@campaign_coordinator = User.find_by_id(@campaign.campaign_coordinator_id)
        @campaign_donation = @campaign.campaign_donations.new
        @volunteers = @campaign.volunteers
        @needs = @campaign.needs
        # @bit_transaction_fee = Campaign.get_btc_fee_balance
        # @eth_transaction_fee = Campaign.get_eth_transaction_fee
        @messages = Message.where(sender_id: current_user.try(:id), receiver_id: @campaign.user_id).or(Message.where(sender_id: @campaign.user_id, receiver_id: current_user.try(:id)))
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
          @good_transactions = CampaignDonation.where(symbol: 'good').where("charity_id = ? or user_id = ?", current_user.id, current_user.id ).order(id: :desc)
          @eth_transactions = CampaignDonation.where(symbol: 'eth').where("charity_id = ? or user_id = ?", current_user.id, current_user.id ).order(id: :desc)
          @btc_transactions = CampaignDonation.where(symbol: 'btc').where("charity_id = ? or user_id = ?", current_user.id, current_user.id ).order(id: :desc)

        elsif current_user.charity_coordinator?
          @good_transactions = CampaignDonation.where(symbol: 'good').where("campaign_coordinator_id = ? or user_id = ?", current_user.id, current_user.id ).order(id: :desc)
          @eth_transactions = CampaignDonation.where(symbol: 'eth').where("campaign_coordinator_id = ? or user_id = ?", current_user.id, current_user.id ).order(id: :desc)
          @btc_transactions = CampaignDonation.where(symbol: 'btc').where("campaign_coordinator_id = ? or user_id = ?", current_user.id, current_user.id ).order(id: :desc)

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
          puts 'Error Send Transaction API: ', current_user.email, send_amount_response.body if params[:symbol]=='good'
          Rails.logger.error "Error Send Transaction API: #{current_user.email}, #{send_amount_response.body}" if params[:symbol]=='good'
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
        if @campaign.update_attributes(campaign_edit_params)
            puts '!!!!!!!!!!!!!!!!!!!!!', params

            # Check if you need to update existing images
			update_existing_images = params[:update_images_attributes]
			existing_images_array_of_ids = params[:images_attributes_existing].blank? ? [] : params[:images_attributes_existing]
			unless update_existing_images.blank?
				if existing_images_array_of_ids.length != @campaign.images.length

					# Loop over each image and if we cannot find it in the array of existing then
					# delete them.. if you dont want this to happen dont include the update_images_attr param
					@campaign.images.each do |image|
						unless existing_images_array_of_ids.include?(image[:id].to_s)
							image.destroy
						end
					end
				end
			end

			# Check if you need to add new images
            unless params[:images_attributes].nil?
                params[:images_attributes].each do |image|
                    @campaign.images.create(image: image)
                end
            end
            redirect_to @campaign, notice: { success: 'Campaign successfully updated!' }
        else
            flash[:error] = 'Error submitting your project; please review and resubmit. Sorry.'
            render :edit
        end
    end

    def get_need
        @need = Need.find(params[:id])
        render json: @need
    end

    # def vol_requested? campaign_id
    #   # bindo
    #   @vol_request  = UsersCampaign.where(user_id: current_user.id, campaign_id: campaign_id)
    #   puts campaign_id @vol_request
    #   if @vol_request
    #     return true
    #   else
    #     return false
    #   end
    # end

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
        # VolunteerRequestMailer.with(@campain_user, current_user.name).send_volunteer_request.deliver_later

        VolunteerRequestMailer.send_volunteer_request(@campain_user, current_user, params[:campaign_id]).deliver_now
        render json: { data: { status: 200, info: @volunteer } }
    end

    def update_status
      @campaign.update!(is_completed: true)
      render json: {
        success: true,
        message: "Project Updated successfully."
      }
    end

    private

    def campaign_params
        params.require(:campaign).permit(
            :name, :campaign_coordinator_id, :description, :goal_amount,
            :good_goal_amount, :region_id, :time_length, :address_city, :address_state,
            :address_country, :address_zip,
                                            campaign_category_ids: [],
                                            needs_attributes: %i[
                                                id description title campaign_id _destroy
                                            ],
                                            volunteers_attributes: %i[
                                                id description title campaign_id hours number _destroy
                                            ]
        )
    end

	def campaign_edit_params
        params.require(:campaign).permit(
            :name, :images, :description, :good_goal_amount,
			:region_id, :address_city, :address_state,
            :address_country, :address_zip, images_attributes: [],
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
        @campaign = Campaign.find(params[:id])
    end
end
