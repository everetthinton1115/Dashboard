class CampaignCategorization < ApplicationRecord
  belongs_to :campaign
  belongs_to :campaign_category
end
