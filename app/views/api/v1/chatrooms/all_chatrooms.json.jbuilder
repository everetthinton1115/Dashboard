json.success true
json.chatroom @chatroom_id do |chatroom|
  chatroom = Chatroom.find(chatroom)
  user = chatroom.user_chatrooms.select(:receiver_id).group(:receiver_id).count.keys.sort
  if chatroom.group_chat == true
    json.id chatroom.id
    json.name chatroom.name
    json.admin chatroom.admin
    json.created_at chatroom.created_at
    json.updated_at chatroom.updated_at
    json.users User.find(user) do |user|
      json.id user.id
      json.name user.name
      json.image_url user.identification_photo.url
    end
  end
end