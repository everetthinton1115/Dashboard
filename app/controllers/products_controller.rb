class ProductsController < ApplicationController
  before_action :authenticate_user, only: [:new, :create, :user_products]
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    if current_user && current_user.super_admin?
      redirect_to admin_root_path and return
    else
      @scope = Product.paginate(:page => params[:page], :per_page => 8)
      filter_products
    end
    respond_to do |format|
      format.js
      format.html
    end
  end

  def user_products
    @scope = current_user.products.paginate(:page => params[:page], :per_page => 6)
    filter_products
  end

  def new
    @product = current_user.products.new
    @product.region_id = current_user.region_id
  end

  def create
    @product = current_user.products.new(product_params)
    authorize @product
    if @product.save
      if params[:images]
        params[:images].each{ |image|
          @product.images.create(image: image)
        }
      end
      redirect_to @product, notice: "Product successfully submitted!"
    else
      flash[:error] = "Error submitting your product; please review and resubmit. Sorry."
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @product.update_attributes(product_params)
      if !params[:images].nil?
        params[:images].each{ |image|
          @product.images.create(image: image)
        }
      end
      redirect_to @product, notice: "Product successfully updated!"
    else
      flash[:error] = "Error submitting your product; please review and resubmit. Sorry."
      render :edit
    end
  end

  def destroy
    @product.destroy
    render json: @product, status: :ok
  end

  # Method for the destroy the product media
  def destroy_product_media
    @image = Image.find(params[:id])
    @image.destroy
    render json: @image, status: :ok
  end

  private
  def product_params
    params.require(:product).permit(:name, :description, :price, :region_id, :address_city, :address_state, :address_country, :address_zip, product_category_ids: [])
  end

  def filter_products
    @scope = @scope.where('products.name ILIKE ?', "%#{params[:search]}%") if params[:search].present?
    @scope = @scope.joins(:product_categories).where(product_categories: {id: params[:product_category]}).distinct if params[:product_category].present?
    @scope = @scope.where(address_country: params[:country]) if params[:country].present?
    @products = @scope
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
