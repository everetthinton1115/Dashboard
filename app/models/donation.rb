class Donation < ApplicationRecord
  validates :donation_amount, presence: true
  validates :sender_address, presence: true
  validates :receiver_address, presence: true
end
