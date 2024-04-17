class InviteMailer < ApplicationMailer

  def registration(user)
    @user = user
    mail(from: "support@commitgood.com", to: [user.email], subject: "Confirmation email")
  end

  def new_wallet_address(user)
    @user = user
    mail(from: "support@commitgood.com", to: "zeshanbutt9128@gmail.com", subject: " New Wallet Address")
  end


  def wallet_address_added(user)
    @user = user
    mail(from: "support@commitgood.com", to: "zeshanbutt9128@gmail.com", subject: "Profile Verified.")
  end

  def new_invite(invite)
    @invite = invite
      mail(from: "support@commitgood.com", to: @invite.receiver_email, subject: " Commit Good Invite from #{@invite.user.name}")
  end

end


