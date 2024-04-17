json.success true
json.chatrooms @chatrooms do |chatroom|

  json.id chatroom.id
  json.name chatroom.name
  json.created_at chatroom.created_at
  json.updated_at chatroom.updated_at
  json.unread_message chatroom.messages.received_by(current_user).unread_by(current_user).count rescue 0
  json.last_message chatroom.messages.last.message rescue ''
  json.last_message_time chatroom.messages.last.created_at rescue ''
  json.status 'Online'

  json.users chatroom.users do |user|
    json.id user.id
    json.name user.name
    json.image_url user.identification_photo.url
    json.role user.roles.first.name
  end

end