class CharitiesCoordinator < ApplicationRecord
  belongs_to :charitable, polymorphic: :true
  belongs_to :user
end
