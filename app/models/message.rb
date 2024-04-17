class Message < ApplicationRecord
  acts_as_readable on: :created_at
  scope :received_by, ->(user) { where.not(sender_id: user) }

  validates :message, presence: true
end