class Video < ApplicationRecord
  belongs_to :user
  belongs_to :campaign

  has_attached_file :video,
                    :path => "/:id/:basename.:extension",
                    :storage => :s3,
                    :https_enabled=> true,
                    :default_url => "600x400.mp4",
                    :s3_protocol => :https,
                    :s3_host_name => 's3.us-east-1.amazonaws.com',
                    :s3_credentials => {
                      s3_region: ENV['AWS_REGION'],
                      bucket: ENV['CAMPAIGN_IMAGE_BUCKET'],
                      access_key_id: ENV['AWS_ACCESS_KEY'],
                      secret_access_key: ENV['AWS_SECRET']
                    }

  validates_attachment :video, content_type:  { content_type: /video/ }
  validates :title, :description, presence: true

  enum status: {
    'New': 0,
    'Uploaded': 1
  }
end
