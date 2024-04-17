include ActionView::Helpers::DateHelper

class Product < ApplicationRecord
  belongs_to :user
  belongs_to :region
  has_many :images, as: :imageable
  has_many :product_categorizations, dependent: :destroy
  has_many :product_categories, through: :product_categorizations
  has_many :votes, as: :voteable, dependent: :destroy

  validates :name, :description, presence: true

  accepts_nested_attributes_for :images

  def s3_url(style = nil, expires_in = 30.minutes)
    image.s3_object(style).url_for(:read, :secure => true, :expires => expires_in).to_s
  end

  def get_image_url url,path
    domain = url.gsub(path,'')
    return domain.concat(image.url)
  end

end
