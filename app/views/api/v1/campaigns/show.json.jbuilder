json.message "success"
json.success true

json. volunteers @campaign_volunteers.each do |volunteer|
  json.id volunteer.id
  json.title volunteer.title
  json.description volunteer.description
  json.campaign_id volunteer.campaign_id
  json.hours volunteer.hours
  json.number volunteer.number
  json.is_applied @campaign.volunteer_appliers.where(volunteer_id: volunteer.id).pluck(:user_id).include?(current_user.id)
  json.status @campaign.volunteer_appliers.where(volunteer_id: volunteer.id, user_id: current_user.id).first.try(:status).to_s.titleize rescue nil
  json.volunteer_needed (@campaign.volunteers.present? && @campaign.volunteers.sum(:number) >= @campaign.volunteer_appliers.where(status: "approved").count)

end