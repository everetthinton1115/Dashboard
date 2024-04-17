class MessagesController < ApplicationController
  
  include RequestAuthenticationModule
  
  before_action :authenticate_user

  def append_message
    if primary_keys_valid
      MessageQueueService.append_message(params[:sig], params[:data])
      if params[:campaign_id].present?
        return render json: { id: params[:campaign_id] }
      else
        return render nothing: true
      end
    end
    render nothing: true
  end

  def index
    @sender_ids = Message.where("sender_id = ? OR receiver_id = ?", current_user.id, current_user.id).pluck(:sender_id).uniq - [current_user.id]
    @sender_user = User.find_by_id(@sender_ids.first)
    @messages = Message.where(sender_id: current_user.try(:id), receiver_id: @sender_user.try(:id)).or(Message.where(sender_id: @sender_user.try(:id), receiver_id: current_user.try(:id)))
    @sender_ids -= [current_user.try(:id)]
    @users = User.where(id: @sender_ids)
  end
  
  def get_messages
    if params[:user_id].present?
      @sender_user = User.find(params[:user_id])
      @messages = Message.where(sender_id: current_user.try(:id), receiver_id: @sender_user.id).or(Message.where(sender_id: @sender_user.id, receiver_id: current_user.try(:id)))
    else
      @messages = []
    end  
  end

  def create_message
    @message = Message.create(sender_id: params[:sender_id], receiver_id: params[:receiver_id], text: params[:message])
  end

end
