class VolunteerApplier < ApplicationRecord
  belongs_to :user
  belongs_to :campaign
  belongs_to :volunteer
  extend FriendlyId
  friendly_id :random_slug, use: :slugged
  def random_slug
    SecureRandom.hex(3)
  end
end
