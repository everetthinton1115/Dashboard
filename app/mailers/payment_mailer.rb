class PaymentMailer < ActionMailer::Base

  def charity_reciept(campaign, symbol, charity_amount)
    @campaign = campaign
    @user = campaign.user
    @symbol = symbol
    @charity_amount = charity_amount
    mail(from: "support@commitgood.com", to: @user.email, subject: "Charity Reciept")
  end

  def doner_reciept(current_user, campaign, symbol, donation_amount, grand_total_amount)
  	@campaign = campaign
  	@user = campaign.user
    @current_user = current_user
    @symbol = symbol
    @donation_amount = donation_amount
    @grand_total_amount = grand_total_amount
    mail(from: "support@commitgood.com", to: @user.email, subject: "Doner Reciept")
  end
  
end


