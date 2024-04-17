class Api::V1::ChatroomsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user

  def index
    begin
      @chatrooms = current_user.chatrooms.where(group_chat: true).includes([:users])
    rescue => e
      render json: { success: false, message: e.message }
    end
  end

  def create
    begin
      @chatroom = Chatroom.new(chatroom_params)
      @chatroom.admin = current_user.id
      @chatroom.group_chat = true
      @chatroom.save!
      @chatroom.user_chatrooms.create!(user_id: current_user.id)
    rescue => e
      render json: { success: false, message: e.message }
    end
  end

  def chatroom_users
    begin
      @chatroom = Chatroom.find(params[:chatroom_id])
      @users = @chatroom.users
    rescue => e
      render json: { success: false, message: e.message }
    end
  end

  def add_users
    begin
      @chatroom = Chatroom.find(params[:chatroom_id])
      receiver = params[:user_ids].split(",").map(&:to_i)
      receiver.each do |receiver_user|
        @user_chatroom = UserChatroom.create!(chatroom_id: @chatroom.id, user_id: receiver_user)
        ApplicationMailer.add_user(receiver_user, @chatroom).deliver_now
      end
      render :create
    rescue => e
      render json: { success: false, message: e.message }
    end
  end

  def remove_users
    begin
      user_ids = params[:user_ids].split(",").map(&:to_i)
      @chatroom = Chatroom.find(params[:chatroom_id])
      @chatroom_user = @chatroom.user_chatrooms.where(user_id: user_ids)
      @chatroom_user.delete_all
      render :create
    rescue => e
      render json: { success: false, message: e.message }
    end
  end
end

private

def chatroom_params
  params.permit(:name, :group_chat, :admin)
end