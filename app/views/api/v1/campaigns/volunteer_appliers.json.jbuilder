json.message "success"
json.success true

json.campiagn_admin_id @campaign.user_id
json.campiagn_id @campaign.id
json.campaign_coordinator @campaign.campaign_coordinator_id
json.working_hours calculate_volunteer_hours
json.volunteer_appliers @volunteer_appliers.each do |applier|
  json.id applier.id
  json.name applier.user.name
  json.wallet_address applier.user.wallet_address
  json.user_id applier.user_id
  json.volunteer_id applier.volunteer_id
  json.image applier.user.identification_photo.url
  json.hours 20
  json.payed [true, false].sample
  json.campiagn_id @campaign.id
end