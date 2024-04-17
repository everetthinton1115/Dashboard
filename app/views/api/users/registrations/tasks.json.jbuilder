json.message "success"
json.success true
# json.working_hours calculate_volunteer_hours
json.working_hours 60

json.tasks @tasks.each do |task|
  json.id task.id
  json.title task.title
  json.hours task.hours
  json.number task.number
  json.campaign_id task.campaign_id
  json.is_applied random_boolean = [true, false].sample
  json.payed random_boolean = [true, false].sample
  json.status random_boolean = ["pending", "approved"].sample.titleize


  json.is_applied task.volunteer_appliers.where(volunteer_id: volunteer.id).pluck(:user_id).include?(current_user.id) rescue false
  json.status task.volunteer_appliers.where(volunteer_id: volunteer.id, user_id: current_user.id).first.try(:status).to_s.titleize rescue nil
end