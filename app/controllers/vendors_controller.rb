class VendorsController < ApplicationController
 
  def index
    @vendors = Alliance.joins(users: :roles).where("roles.name = ? ", "vendor")
    @vendors = @vendors.where("users.address_country = ?", params[:country]) if params[:country].present?
    @vendors = @vendors.where('alliances.name ILIKE ?', "%#{params[:search]}%") if params[:search].present?
    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
    @vendor = Alliance.find(params[:id])
  end

  def edit
    @vendor = Alliance.find(params[:id])
    authorize @vendor
    render layout: "form_page"
  end

  def update
    @vendor = Alliance.find(params[:id])
    authorize @vendor
    if @vendor.update_attributes(vendor_params)
     flash[:success] = "Vendor Updated!"
     redirect_to @vendor
    else
       render 'edit'
    end
  end

  private

  def vendor_params
    params.require(:alliance).permit(:contact_email, :name, :description, :region_id, :logo, :church_category_id, :website_url, :facebook_url, :twitter_url, :gplus_url)
  end

end
