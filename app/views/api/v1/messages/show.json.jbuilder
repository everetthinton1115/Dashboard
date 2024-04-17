json.success true
json.message @message do |message|
  json.chatroom_id message.chatroom_id
  json.id message.id
  json.sender_id message.sender_id
  json.receiver_id message.receiver_id
  json.message message.message
  json.created_at message.created_at
  json.updated_at message.updated_at
  json.sender do
    json.sender_id @sender.id
    json.sender_name @sender.name
    json.sender_image_url @sender.identification_photo.url
  end
end
