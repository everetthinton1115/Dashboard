class Region < ApplicationRecord
  include Geospatial
  has_many :churches
  has_many :alliances
  has_many :events
  has_many :ads
  has_many :campaigns
end
