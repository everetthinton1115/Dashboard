class NftsController < ApplicationController
  def new
    @nft = Nft.new(campaign_id: params[:campaign_id])
  end

  def edit
    @nft = Nft.where(id: params[:id]).first
  end

  def create
    @nft = Nft.new(nft_params)
    @nft.user_id = current_user.id

    if @nft.save
      flash[:notice] = {success: "Your nft is added"}
      redirect_to campaign_path(@nft.campaign_id)
    else
      flash[:error] = 'Error submitting your nft; please review and resubmit. Sorry.'
      render :new
    end
  end

  def update
    @nft = Nft.where(id: params[:id]).first

    if @nft.update(nft_params)
      flash[:notice] = {success: "Your nft is updated"}
      redirect_to campaign_path(@nft.campaign_id)
    else
      flash[:error] = 'Error submitting your nft; please review and resubmit. Sorry.'
      render :edit
    end
  end

  private

  def nft_params
    params.require(:nft).permit(:name, :price, :description, :campaign_id, :image)
  end
end