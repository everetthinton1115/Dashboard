json.success true
json.users @users do |user|
  json.id user.id
  json.name user.name
  json.image_url user.identification_photo.url
end