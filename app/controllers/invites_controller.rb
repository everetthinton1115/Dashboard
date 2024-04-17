class InvitesController < ApplicationController
  # before_action :authenticate_user

  def index
    user = User.find_by(token: params[:token])
    if user
      user.update(confirmed_at: Time.now)
    end
    redirect_to ENV["HOST_URL"]+"login"
  end

  def new
    @invite = Invite.new
  end

  def create
    @invite = current_user.invites.new(invite_params)
    @invite.status = "pending"
    if @invite.save
      InviteMailer.new_invite(@invite).deliver_now
      redirect_to invites_path, notice: 'Invitation has been sent'
    else
      redirect_to documents_path, notice: 'Cannot send invitation. Please try again later'
    end
  end

  private

  def invite_params
    params.require(:invite).permit(:sender_email, :receiver_email, :subject, :body)
  end
end
