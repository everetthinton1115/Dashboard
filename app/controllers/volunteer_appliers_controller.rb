class VolunteerAppliersController < ApplicationController
  require 'sendgrid-ruby'
  include SendGrid
  def create
    @volunteer_applier = VolunteerApplier.new(campaign_id: params[:campaign_id], user_id: params[:user_id],volunteer_id: params[:volunteer_id], status: "pending", number_of_hours: params[:hours])
    @volunteer_applier.save
    @campaign = Campaign.find(params[:campaign_id])
    @volunteer = User.find(params[:user_id])
    puts "API KEY ======================?>     #{ENV["SENDGRID_API_KEY"]}"
    VolunteerRequestMailer.send_volunteer_request(@campaign, @volunteer, params[:campaign_id],  params[:hours], @volunteer_applier.id ).deliver_now
    # ApplicationMailer.new_volunteer_applier(@volunteer_applier).deliver_now
  
  end

end
