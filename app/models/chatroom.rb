class Chatroom < ApplicationRecord
  has_many :user_chatrooms, dependent: :destroy
  has_many :users, through: :user_chatrooms
  has_many :messages, dependent: :destroy
  scope :find_by_name, ->(user_sender, receiver) { where(name: "#{user_sender},#{receiver}").or(self.where(name: "#{receiver},#{user_sender}"))}

  # validates :name, uniqueness: true
end
