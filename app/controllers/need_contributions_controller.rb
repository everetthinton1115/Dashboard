class NeedContributionsController < ApplicationController

  def create
    @need_contribution = NeedContribution.new(campaign_id: params[:campaign_id], user_id: params[:user_id],need_id: params[:need_id], status: "pending")
    @campaign = Campaign.find_by_id(params[:campaign_id])
    @need_contribution.save
    ApplicationMailer.new_need_contribution(@need_contribution).deliver_now
    render json: {
      needContributionId: @need_contribution.id,
      donor: @need_contribution.user.wallet.meta_address,
      donorId: @need_contribution.user_id, 
      charity: @campaign.user.wallet.meta_address,
      charityId: @campaign.user_id,
      campaignId: @campaign.id,
      status: :ok 
    }
  end

end
