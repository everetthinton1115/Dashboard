class CampaignCategory < ApplicationRecord
  has_many :campaign_categorizations
  has_many :campaigns, through: :campaign_categorizations
end
