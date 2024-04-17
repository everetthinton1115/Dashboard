class VolunteerRequestMailer < ApplicationMailer
  require 'sendgrid-ruby'
  include SendGrid
  def send_volunteer_request(camapin_owner, volunteer, campaign_id, hours, id, project)
    @user = camapin_owner.user.email
    @volunteer_name = volunteer.name
    @volunteer = project.id
    @campaign = Campaign.find(campaign_id)
    @campaign_slug = @campaign.id.to_s
    @hours = hours
    @apply_slug = VolunteerApplier.find(id).slug
    @project = project
    host_url = ENV["HOST_URL"]

    from = Email.new(email: 'support@commitgood.com', name: "Commit Good")
    to = Email.new(email: camapin_owner.user.email)
    subject = 'GOOD Gig Request'
    content = Content.new(type: 'text/html', value: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
          <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <title>Invitation Mail</title>
          </head>
          <body>
            <table width="600" border="0" align="center" style="padding:0px; background-color:#f3f4f5; font-family:Arial, Helvetica, sans-serif; font-size:13px; color:#333; border: 1px solid #ccc;">
              <tr style="background-color: #234480;">
                <td align="center" style="padding: 20px 0;" colspan="3"><a href="#"><img width=""  ></a></td>
              </tr>
              <tr>
                <td style="padding:0 10px;" colspan="3">
                  <div style="width: 80%; background-color: #fff; border-bottom: 2px solid #e3e6e9; padding: 20px; margin: 30px auto">
                    <h1 style="color: #4f687a; font-size: 18px;">Hi this is  '+"#{@volunteer_name}"+' </h1>
                    <p style="font-size: 14px; line-height: 20px;">I wanted to be GOOD Gig worker for your project '+"#{@campaign.name}"+' in task '+"#{@project.description}"+' with '+"#{@hours}"+' Hrs.</p>
                  </div>
                </td>
              </tr>
              <tr>
                <td style="padding:5px 10px;" colspan="2">
                  <hr style="background-color: #ddd; color: #ddd" >
                </td>       
              </tr>
              <tr>
              </tr>
              <tr style="background-color: #234480; color: #fff; border: 0;">
                <td style="padding: 15px;" colspan="3" align="right">
                  <div align="right" style="padding: 20px">
                      <a style="border-radius: 5px; background-color: #ff8a8a; padding: 10px;text-decoration: none; color: #000" class="btn btn-outline-danger" href=' + "#{host_url}"+'>Reject</a>
                        <a style="border-radius: 5px; background-color: #c9c9c9; text-decoration: none; padding: 10px; color: #000"  href=' + "#{host_url}"+ 'api/v1/volunteer_interest/'+"#{@campaign_slug}"+'/accept/'+"#{@apply_slug}"+'>Accept</a>
                    </div>
                </td>
              </tr>
            </table>
          </body>
        </html>')
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
    # make_bootstrap_mail(from: "cbraswell777@gmail.com", to: camapin_owner.user.email, subject: "Campaign Request")

  end

  def campaign_accept_mailer(campaign, volunteer)
    @vol_name = volunteer.name
    @campaign_name = campaign.name
    # make_bootstrap_mail(from: "nageswararao.nyros@gmail.com", to: volunteer.email, subject: "Request Accepted")
    from = Email.new(email: 'support@commitgood.com', name: "Commit Good")
    to = Email.new(email: volunteer.email)
    subject = 'Request Accepted'
    content = Content.new(type: 'text/html', value: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
          <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <title>Invitation Mail</title>
          </head>
          <body>
            <table width="600" border="0" align="center" style="padding:0px; background-color:#f3f4f5; font-family:Arial, Helvetica, sans-serif; font-size:13px; color:#333; border: 1px solid #ccc;">
              <tr style="background-color: #234480;">
                <td align="center" style="padding: 20px 0;" colspan="3"><a href="#"><img width=""  ></a></td>
              </tr>
              <tr>
                <td style="padding:0 10px;" colspan="3">
                  <div style="width: 80%; background-color: #fff; border-bottom: 2px solid #e3e6e9; padding: 20px; margin: 30px auto">
                    <h1 style="color: #4f687a; font-size: 18px;">Congratulations  '+"#{@vol_name}"+' </h1>
                    <p style="font-size: 14px; line-height: 20px;">Your request accepted and you will be the GOOD Gig worker of '+"#{@campaign_name}"+' </p>
                  </div>
                </td>
              </tr>
              <tr>
                <td style="padding:5px 10px;" colspan="2">
                  <hr style="background-color: #ddd; color: #ddd" >
                </td>       
              </tr>
              <tr>
              </tr>

            </table>
          </body>
        </html>')
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers

  end
end
