json.message "success"
json.success true
json.working_hours 60

json.volunteers @tasks.each do |volunteer|
  json.id volunteer.id
  json.title volunteer.title
  json.description volunteer.description
  json.campaign_id volunteer.campaign_id
  json.hours volunteer.hours
  json.number volunteer.number
  json.is_applied true
  # json.status volunteer.status
end