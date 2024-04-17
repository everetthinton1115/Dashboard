class Volunteer < ApplicationRecord
	belongs_to :campaign
	has_many :volunteer_contributions
  has_many :volunteer_appliers, dependent: :destroy
  has_many :users_campaigns

  validates :title, :description, :hours, :number, presence: true
end
