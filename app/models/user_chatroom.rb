class UserChatroom < ApplicationRecord
  belongs_to :chatroom
  belongs_to :user

  validates_uniqueness_of :user_id, scope: [:chatroom_id]
end
