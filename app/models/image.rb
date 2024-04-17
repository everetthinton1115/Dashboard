class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true

  has_attached_file :image,
    :path => "/:id/:basename.:extension",
    :storage => :s3,
    :https_enabled=> true,
    styles: { medium: "375x330>" },
    :default_url => "600x400.png",
    :s3_protocol => :https,
    :s3_host_name => 's3.us-east-1.amazonaws.com',
    :s3_credentials => {
      s3_region: ENV['AWS_REGION'],
      bucket: ENV['CAMPAIGN_IMAGE_BUCKET'],
      access_key_id: ENV['AWS_ACCESS_KEY'],
      secret_access_key: ENV['AWS_SECRET']
    }

  validates_attachment :image, content_type:  { content_type: /image/ }
end