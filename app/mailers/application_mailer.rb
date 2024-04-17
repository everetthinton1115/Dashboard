class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  # layout 'mailer'
  # layout 'bootstrap-mailer'
  require 'sendgrid-ruby'
  include SendGrid
  def new_volunteer_applier(volunteer_applier)
    @user = volunteer_applier.user
     mail(from: "clay@commitgood.com", to: @user.email, subject: "Confirmation")
  end

  def forget_password(user, token)
    @user = user
    @token = token
    mail(from: "support@commitgood.com", to: user.email, subject: "Recover Password")
  end

  def add_user(user, chatroom)
    @admin = User.find(chatroom.admin)
    @user = User.find(user)
    @chatroom_name = chatroom.name
    mail(from: "support@commitgood.com", to: @user.email, subject: "Add in Chatroom")
  end

  def confirmation_mail(user)
    # @vol_name = volunteer.name
    # @campaign_name = campaign.name
    # make_bootstrap_mail(from: "nageswararao.nyros@gmail.com", to: volunteer.email, subject: "Request Accepted")
    from = Email.new(email: 'support@commitgood.com', name: "Commit Good")
    to = Email.new(email: user.email)
    subject = 'Confirmation Email'
    content = Content.new(type: 'text/html', value: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
          <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <title>Invitation Mail</title>
          </head>
          <body>
            <table width="600" border="0" align="center" style="padding:0px; background-color:#f3f4f5; font-family:Arial, Helvetica, sans-serif; font-size:13px; color:#333; border: 1px solid #ccc;">
              <tr style="background-color: #234480;">
                <td align="center" style="padding: 20px 0;color: #fff;" colspan="3"><h2>Commit Good</h2></td>
              </tr>
              <tr>
                <td style="padding:0 10px;" colspan="3">
                  <div style="width: 80%; background-color: #fff; border-bottom: 2px solid #e3e6e9; padding: 20px; margin: 30px auto">
                    <h1 style="color: #4f687a; font-size: 18px;"> Confirmation </h1>
                    <p style="font-size: 14px; line-height: 20px;"> Please confirm your account and login here <a href="'+ENV['HOST_URL']+'user/'+"#{user.confirm_token}"+'/confirm" style="border: 0;background-color: #597eeb;color: #fff;font-size: 14px;padding: 5px 20px; text-decoration: none;">Login</a></p>
                  </div>
                </td>
              </tr>
            </table>
          </body>
        </html>')
    mail = Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    # if response.status_code == "202"
    #   return true
    # else
    #   return false
    # end
    puts response.status_code
    puts response.body
    puts response.headers
  end

  def new_need_contribution(need_contributer)
    @user = need_contributer.user
     mail(from: "clay@commitgood.com", to: @user.email, subject: "For need contributer")
  end

  def nft_is_purchased(nft)
    @tx_id = nft.tx_id
    mail(from: "support@commitgood.com", to: 'zeshanbutt9128@gmail.com', subject: "NFT is Purchased")
  end

  def nft_is_sold(nft)
    @tx_id = nft.tx_id
    mail(from: "support@commitgood.com", to: 'zeshanbutt9128@gmail.com', subject: "NFT is Sold")
  end


end
