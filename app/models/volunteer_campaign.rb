class VolunteerCampaign < ApplicationRecord
  belongs_to :volunteer
  belongs_to :campaign
end
