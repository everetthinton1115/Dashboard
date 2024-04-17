class AlliancesController < ApplicationController
  def index
    @alliances = Alliance.all
    # @alliances = Alliance.joins(users: :roles).where("roles.name = ? ", "charity_admin")
    @alliances = @alliances.includes(:users).where(users: {address_country: params[:country]}) if params[:country].present?
    @alliances = @alliances.where('name ILIKE ?', "%#{params[:search]}%") if params[:search].present?
	  @alliances = @alliances.paginate(:page => params[:page], :per_page => 8)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
    @alliance = Alliance.find(params[:id])
    @charitable_donation = @alliance.charitable_donations.new donation_amount: 20
    # render layout: "landing_page"
  end

  def edit
    @alliance = Alliance.find(params[:id])
    authorize @alliance
    render layout: "form_page"
  end

  def update
    @alliance = Alliance.find(params[:id])
    authorize @alliance
    if @alliance.update_attributes(alliance_params)
     flash[:success] = "Alliance Updated!"
     redirect_to @alliance
    else
       render 'edit'
    end
  end

  private
  def alliance_params
    params.require(:alliance).permit(:contact_email, :name, :description, :region_id, :logo, :church_category_id, :website_url, :facebook_url, :twitter_url, :gplus_url, :campaign_coordinator_id)
  end

  def alliance_charity_by_name
    @alliances = @alliances.where('alliances.name ILIKE ?', "%#{params[:search]}%") if params[:search]
  end
end
