class Api::CoordinatorsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user
    before_action :campaign, except: [:get_volunteered_projects, :goods_wallet_balance]
    before_action :user

    def get_volunteered_projects
        
        if @user.super_admin?
            @scope = []
        elsif @user.charity_coordinator?
            @scope = Campaign.where(campaign_coordinator_id: @user.id).paginate(page: params[:page], per_page: 8)
            fillter_campaigns  
        else
            @scope = Campaign.paginate(page: params[:page], per_page: 8)
            fillter_campaigns
        end
        
        if params[:state] == "successful"
            @campaigns = @campaigns.successful
        else
            @campaigns = @campaigns.open
        end
        campaigns = @campaigns.map do |campaign|
            Campaign.api_values(campaign, params["user_id"].to_i)
        end
        render json: { data: campaigns }.to_json, status: 200
    end

    def select_volunteer
		@campaign_coordinator = User.find(@campaign.campaign_coordinator_id)
        @campaign_donation = @campaign.campaign_donations.new
        @volunteers = @campaign.volunteers
        @needs = @campaign.needs
        
        @messages = Message.where(sender_id: @user.try(:id), receiver_id: @campaign.user_id).or(Message.where(sender_id: @campaign.user_id, receiver_id: @user))

        render json: { 
            data: Campaign.api_values(@campaign, params["user_id"].to_i), 
            campaign_coordinator: @campaign_coordinator, 
            campaign_donation: @campaign_donation,
            volunteers: @volunteers, 
            needs: @needs,
            messages: @messages
        }.to_json, status: 200
    end 

    def check_in
        radius = Campaign.distance_between_two_locations(@campaign.lat_lng, [params[:lat], params[:lng]] ) rescue 0
        
        if radius < 50
            response = @campaign.check_in(params[:user_id])
            render json: response.to_json, status: 200
        else
            render json: { 
              data: "invalid", 
              reason: "Out of Radius"
            }.to_json, status: 200
        end
    end  

    def check_out
        radius = Campaign.distance_between_two_locations(@campaign.lat_lng, [params[:lat], params[:lng]] ) rescue 0
        
        if true || radius < 50
            response = @campaign.check_out(params[:user_id])
            render json: response.to_json, status: 200
        else
          render json: { data: "invalid", reason: "Out of Radius"}.to_json, status: 200
        end
    end  

    def goods_wallet_balance
        wallet = CampaignCheckInHistory.where(user_id: params["user_id"])

        if wallet.present?
            sum = 0
            wallet.map(&:tokens).each do |token|
                sum+= token.to_f
            end
            
            render json: {
                wallet_balance:{
                    tokens: sum.to_i,
                    user_id: params["user_id"].to_i
                }
            }.to_json, status: 200
        else
            render json: { 
                msg: "No Wallet found against this user."
            }.to_json, status: 200
        end
    end

    def coordinators_list
        @role = Role.find_by(name: 'charity_coordinator')
        @user_roles = UserRole.where(role_id: @role.id)
        @coordinators_list = []
		puts "TOTAL LENGTH", @user_roles.length
        @user_roles.each do |role|
            next unless role.user.present?

            @user = role.user
			coordinator = {
				'name': @user.name,
				'email': @user.email,
				'location': @user.location_name,
				'lat': @user.lat,
				'lng': @user.lng,
				'image': @user.profile.url(:thumb)
			}

            @coordinators_list << coordinator
        end
        render json: { data: @coordinators_list }.to_json, status: 200
    end

    def fillter_campaigns
        @scope = @scope.where('campaigns.name ILIKE ?', "%#{params[:search]}%") if params[:search].present?
        if params[:campaign_category].present?
            @scope = @scope.joins(:campaign_categories).where(campaign_categories: { id: params[:campaign_category] }).distinct
        end
        @scope = @scope.where(address_country: params[:country]) if params[:country].present?
        @campaigns = @scope.order(created_at: :desc)
    end

    private
    def authenticate_user
        return unless params[:user_id].present?
        
        @user = User.where(id: params[:user_id]).first
        return render json: {
            message: 'User not found',
            status: 401
        } unless @user.present?

    end

    def campaign
        campaign_id = params[:action] == "select_volunteer" ? params[:id] : params[:campaign_id]
        @campaign ||= Campaign.find_by(id: campaign_id)
        unless @campaign
            return render json: { 
                data: "invalid", 
                reason: "Campaign not found"
            }.to_json, status: 200
        end
    end

    def user
        @user ||= User.find_by(id: params[:user_id])
        
        unless @user
            return render json: { 
                data: "invalid", 
                reason: "User not found"
            }.to_json, status: 200
        end
    end
end
