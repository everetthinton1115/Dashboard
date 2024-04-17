class Transaction < ApplicationRecord
  belongs_to :campaign
  belongs_to :user

  validates :tx_id, presence: true, allow_nil: false, uniqueness: { case_sensitive: false }
  validates :amount_in_eth, presence: true, allow_nil: false
end
