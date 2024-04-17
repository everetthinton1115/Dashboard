json.message "success"
json.success true

json.id @user.id
json.name @user.name
json.email @user.email
json.address_line1 @user.address_line1
json.address_line2 @user.address_line2
json.city @user.address_city
json.state @user.address_state
json.county @user.address_country
json.zip @user.address_zip
json.image_url @user.profile.url
json.facebook_url @user.facebook_url
json.linkedin_url @user.linkedin_url
json.website_url @user.website_url
json.role @user.roles.first.name
json.wallet_status @user.wallet_status
json.limit  @user.limit