class Alliance < ApplicationRecord
  include AASM
  include LastPeriods

  belongs_to :area_of_interest
  belongs_to :region, optional: true
  has_many :users
  has_many :charitable_donations, as: :charity

  has_attached_file :logo,
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
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/

  has_attached_file :verification_doc,
          :path => "/:id/:basename.:extension",
          :storage => :s3,
          :https_enabled=> true,
          :s3_protocol => :https,
          :s3_host_name => 's3.us-east-1.amazonaws.com',
          :s3_credentials => {
            s3_region: ENV['AWS_REGION'],
            bucket: 'commitgood-charity-503-documents',
            access_key_id: ENV['AWS_ACCESS_KEY'],
            secret_access_key: ENV['AWS_SECRET']
          }

  validates_attachment_content_type :verification_doc, :content_type => ["application/pdf","application/     vnd.ms-excel",
             "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
             "application/msword",
             "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
             "text/plain","image/jpeg","image/png","image/jpg"]

  validates :name, presence: true, if: :user_exist?
  # validates :verification_doc, presence: true 

  aasm :approval_state do
    state :new, initial: true
    state :approved
    state :denied

    event :approve do
      transitions from: [:new], to: :approved
    end
  end

  def admin_users
    users.joins(:user_roles).where user_roles: {role_id: Role.alliance_admin.id}
  end

  def user_exist?
    persisted?
  end
end
