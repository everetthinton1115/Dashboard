json.message "success"
json.success true
json.id @campaign.id
json.name @campaign.name
json.description @campaign.description
json.user_id @campaign.user_id
json.goal_amount @campaign.goal_amount
json.total_amount @campaign.total_amount
json.expiration_date @campaign.expiration_date
json.workflow_state @campaign.workflow_state
json.time_length @campaign.time_length
json.address_city @campaign.address_city
json.address_state @campaign.address_state
json.address_country @campaign.address_country
json.address_zip @campaign.address_zip
json.campaign_coordinator_id @campaign.campaign_coordinator_id
json.good_goal_amount @campaign.good_goal_amount
json.total_good_amount @campaign.total_good_amount
json.days_left [(@campaign.expiration_date - Date.today).to_i, 0].max rescue 0
json.is_completed @campaign.is_completed
json.donation_amount_in_good @campaign.transactions.sum(:amount_in_good)
json.donation_amount_in_usd @campaign.transactions.sum(:amount_in_usd)
json.donation_amount_in_eth @campaign.transactions.sum(:amount_in_eth)
json.ready_for_reward check_reward_percentage(@campaign)
json.total_volunteers @campaign.volunteers.sum(:number)
if current_user
  json.volunteer_applied @campaign.volunteer_appliers.pluck(:user_id).include?(current_user.id)
else
  json.volunteer_applied false
end

json.profile_image @campaign.user.profile.url(:thumb)
json.user_name @campaign.user.name
json.volunteer_needed (@campaign.volunteers.present? && @campaign.volunteers.sum(:number) >= @campaign.volunteer_appliers.where(status: "approved").count)
json.images @campaign.images.each do |image|
  json.image_url image.image.url rescue "https://imgv3.fotor.com/images/slider-image/goart_guide_pc_now_2_2021-12-01-073524.jpg"
end

json.coordinator_name User.find_by_id(@campaign.campaign_coordinator_id).try(:name)
json.coordinator_image_url User.find_by_id(@campaign.campaign_coordinator_id).try(:profile).try(:url)

json.videos @campaign.videos.each do |video|
  json.id video.id
  json.title video.title
  json.description video.description
  json.status video.status
  json.video_url video.video.url
  json.user_id video.user_id
  json.user_name video.user.name
  json.user_image_url video.user.profile.url
end