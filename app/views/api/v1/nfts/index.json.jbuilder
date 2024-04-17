json.message "success"
json.success true

json.nft @nft.each do |nft|
  json.id nft.id
  json.title nft.title
  json.price nft.price
  json.description nft.description
  json.campaign_id nft.campaign_id
  json.created_by nft.created_by
  json.token nft.token
  json.reward_title nft.reward_title rescue ""
  json.redeem_limit nft.redeem_limit
  json.remaining_limit nft.remaining_limit
  json.image nft.image.url
  json.mint_id nft.mint_id
  json.charity_name nft.campaign.try(:name)
  json.nft_status nft.nft_status
  json.owner_id nft.user_id
  json.image_url nft.user.profile.url(:thumb) rescue nil

  if nft.images.present?
    json.merchant_images nft.images.each do |image|
      json.merchant_image_url image.image.url
    end
  else
    json.merchant_images []
  end

end