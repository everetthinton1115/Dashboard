json.message "success"
json.success true
if @campaigns.present?
  json.data @campaigns.each do |campaign|
    json.id campaign.id
    json.name campaign.name
    json.description campaign.description
    json.user_id campaign.user_id
    json.goal_amount campaign.goal_amount
    json.total_amount campaign.total_amount
    json.expiration_date campaign.expiration_date
    # json.workflow_state campaign.workflow_state
    json.time_length campaign.time_length
    json.address_city campaign.address_city
    json.address_state campaign.address_state
    json.address_country campaign.address_country
    json.address_zip campaign.address_zip
    json.campaign_coordinator_id campaign.campaign_coordinator_id
    json.good_goal_amount campaign.good_goal_amount
    json.total_good_amount campaign.total_good_amount
    json.days_left [(campaign.expiration_date - Date.today).to_i, 0].max rescue 0
    json.is_completed campaign.is_completed
    json.user_image campaign.user.profile.url
    json.donation_amount_in_good campaign.transactions.sum(:amount_in_good)
    json.donation_amount_in_usd campaign.transactions.sum(:amount_in_usd)
    json.donation_amount_in_eth campaign.transactions.sum(:amount_in_eth)
    json.total_volunteers campaign.volunteers.sum(:number)


    if current_user
      json.volunteer_applied campaign.volunteer_appliers.pluck(:user_id).include?(current_user.id)
    else
      json.volunteer_applied false
    end
    json.volunteer_needed (campaign.volunteers.present? && campaign.volunteers.sum(:number) >= campaign.volunteer_appliers.where(status: "approved").count)
    json.images campaign.images.each do |image|
      json.image_url image.image.url rescue "https://imgv3.fotor.com/images/slider-image/goart_guide_pc_now_2_2021-12-01-073524.jpg"
    end

  end
else
  json.data []
end
