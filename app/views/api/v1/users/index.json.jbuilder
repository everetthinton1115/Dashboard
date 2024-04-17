json.users @users do |user|
  json.id user.id
  json.name user.name
  json.image_url user.identification_photo.url
  json.email  user.email
  json.limit  user.limit
  chatroom = Chatroom.find_by_name(current_user.id, user.id)
  if chatroom.present?
    json.unread_message chatroom.first.messages.received_by(current_user).unread_by(current_user).count rescue 0
    json.status 'Online'
    json.recent_message chatroom.first.messages.last.message rescue 'First Message'
    json.recent_message_time chatroom.first.messages.last.created_at rescue Time.now
  end
end