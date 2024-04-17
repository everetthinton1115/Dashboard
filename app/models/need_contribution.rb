class NeedContribution < ApplicationRecord
  belongs_to :user
  belongs_to :need
  belongs_to :campaign
end
