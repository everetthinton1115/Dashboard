class VotesController < ApplicationController
  before_action :authenticate_user
  before_action :set_entity

  def create
    if already_voted?
      msg = "You can't vote more than once"
      status = "warning"
    else
      @entity.votes.create(user_id: current_user.id)
      count = @entity.votes.count
      msg = "Successfully voted"
      status = "success"
    end
    count = @entity.votes.count
    render json: { entity: @entity, count: count, status: status, message: msg}
  end

  private
  def set_entity
    @entity = params[:campaign_id].present? ? Campaign.find(params[:campaign_id]) 
                                            : Product.find(params[:product_id])
  end

  def already_voted?
    @entity.votes.where(user_id: current_user.id).exists?
  end
end
