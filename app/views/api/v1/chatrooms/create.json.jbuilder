json.success true
json.id @chatroom.id
json.name @chatroom.name
json.group_chat @chatroom.group_chat
json.admin @chatroom.admin
json.created_at @chatroom.created_at
json.updated_at @chatroom.updated_at
json.users @chatroom.users do |user|
  json.id user.id
  json.name user.name
  json.image_url user.identification_photo.url
end