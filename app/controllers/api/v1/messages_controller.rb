class Api::V1::MessagesController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user

  def index
    begin
      @messages = Message.where(chatroom_id: params[:chatroom_id])
      @messages.mark_as_read! :all, for: current_user
      render json: { success: true, message: @messages }

    rescue => e
      render json: { success: false, message: e.message }
    end
  end

  def create
    begin
      name = "#{current_user.id},#{params[:receiver_id]}"
      users = params[:receiver_id].split(",").map(&:to_i).push(current_user.id).sort
      @chatroom = Chatroom.find_by_name(current_user.id, params[:receiver_id])
      if @chatroom.present?
        @message = Message.create!(sender_id: current_user.id, receiver_id: params[:receiver_id], chatroom_id: @chatroom.ids[0], message: params[:message])
        @sender = current_user
      else
        @chatroom = Chatroom.create!(name: name, admin: current_user.id)
        users.each do |user|
          @chatroom.user_chatrooms.create!(user_id: user)
        end
        @message = Message.create!(sender_id: current_user.id, receiver_id: params[:receiver_id], chatroom_id: @chatroom.id, message: params[:message])
        @sender = current_user
      end
    rescue => e
      render json: { success: false, message: e.message }
    end
  end

  def group_message
    begin
      @chatroom = Chatroom.find(params[:chatroom_id])
      @sender = current_user
      @message = @chatroom.messages.create!(message: params[:message], sender_id: @sender.id)
      render :create
    rescue => e
      render json: { success: false, message: e.message }
    end
  end

  def show
    begin
      @receiver = User.find_by_id(params[:id])
      @sender = current_user
      @chatroom = Chatroom.find_by_name(current_user.id, params[:id])
      if @chatroom.present?
        @message = @chatroom.first.messages
        @message.mark_as_read! :all, for: current_user
      else
        @message = []
      end
    rescue => e
      render json: { success: false, message: e.message }
    end
  end
end

private

def message_params
  params.permit(:sender_id, :receiver_id, :chatroom_id, :message)
end