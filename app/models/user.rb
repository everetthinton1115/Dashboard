class User < ApplicationRecord
  # Include default devise modules. Others available are::confirmable, :timeoutable,,
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :omniauthable
  # include LastPeriods
  acts_as_reader

  scope :all_except, ->(user) { where.not(id: user) }
  # Not sure if we use region anymore.. but dont need to assign people to the others
  # belongs_to :region, optional: true
  belongs_to :alliance, optional: true
  # belongs_to :business, optional: true
  belongs_to :church, optional: true

  has_many :subscriptions, dependent: :destroy
  has_many :user_roles
  has_many :roles, through: :user_roles
  # has_many :charity_coordinators, through: :charities_coordinators
  has_many :videos, dependent: :destroy
  has_many :resources
  has_many :ads
  has_many :user_areas_of_interest
  has_many :areas_of_interest, through: :user_areas_of_interest
  has_many :charitable_donations
  has_many :campaign_donations
  has_many :campaigns
  has_many :attendees
  has_many :payments
  has_many :events

  has_many :charities_coordinators, as: :charitable

  # has_many :commented_timesheets, through: :comments, source: :commentable, source_type: 'User'
  has_one :job_lead
  has_one :card
  has_one :wallet
  has_many :invites
  has_many :volunteer_appliers
  has_many :need_contributions
  has_many :products
  has_many :users_campaigns
  has_many :user_chatrooms
  has_many :chatrooms, through: :user_chatrooms
  has_many :messages
  has_many :nfts, dependent: :destroy

  accepts_nested_attributes_for :alliance, :church

  after_create :subscribe_user_to_mailing_list
  after_create :add_alliance_description
  after_create :update_invite_status

  validates :name, presence: true, length: { maximum: 50 }
  # validate :length_of_name_and_format, if: -> { name? }
  validates :name, presence: true
  validate :current_password_match

  validates :email, presence: true, length: { maximum: 100 }
  validates :email, uniqueness: true, allow_blank: true
  validates :wallet_address, uniqueness: true
  validate :format_of_email, if: -> { email.present? }

  validates :password, presence: true, length: { maximum: 50 }, on: :create, if: :password_required?
  validates :password, presence: false, length: { maximum: 50 }, on: :update
  validate :length_of_password, if: -> { password.present? }

  validates :password_confirmation, presence: true, on: :create, if: :password_required?
  validates :password_confirmation, presence: false, on: :update
  # validates :roles, presence: true
  validates :address_line1, :address_country, :address_state, presence: true
  # validates :address_line2, presence: true
  validates :uuid, uniqueness: true, allow_blank: true
  # validates :address_zip, presence: true

  # PROFILE IMAGE
  has_attached_file :profile,
                    path: '/:id/:basename.:extension',
                    storage: :s3,
                    https_enabled: true,
                    styles: { medium: '375x330>' },
                    default_url: '600x400.png',
                    s3_protocol: :https,
                    s3_host_name: 's3.us-east-1.amazonaws.com',
                    s3_credentials: {
                      s3_region: ENV['AWS_REGION'],
                      bucket: ENV['USER_PROFILE_BUCKET'],
                      access_key_id: ENV['AWS_ACCESS_KEY'],
                      secret_access_key: ENV['AWS_SECRET']
                    }
  validates_attachment_content_type :profile, content_type: %r{\Aimage/.*\z}

  # SELFIE IMAGE FOR IDENTIFICATION
  has_attached_file :identification_photo,
                    styles: { medium: '300x300>' },
                    default_url: '/images/:style/missing.png',
                    path: '/:id/:basename.:extension',
                    storage: :s3,
                    https_enabled: true,
                    s3_protocol: :https,
                    s3_host_name: 's3.us-east-1.amazonaws.com',
                    s3_credentials: {
                      s3_region: ENV['AWS_REGION'],
                      bucket: ENV['USER_PROFILE_BUCKET'],
                      access_key_id: ENV['AWS_ACCESS_KEY'],
                      secret_access_key: ENV['AWS_SECRET']
                    }
  validates_attachment_content_type :identification_photo, content_type: %r{\Aimage/.*\z}

  # DRIVER LICENSE FOR IDENTIFICATION
  has_attached_file :license_photo,
                    styles: { medium: '300x300>' },
                    default_url: '/images/:style/missing.png',
                    path: '/:id/:basename.:extension',
                    storage: :s3,
                    https_enabled: true,
                    s3_protocol: :https,
                    s3_host_name: 's3.us-east-1.amazonaws.com',
                    s3_credentials: {
                      s3_region: ENV['AWS_REGION'],
                      bucket: ENV['USER_PROFILE_BUCKET'],
                      access_key_id: ENV['AWS_ACCESS_KEY'],
                      secret_access_key: ENV['AWS_SECRET']
                    }
  validates_attachment_content_type :license_photo, content_type: %r{\Aimage/.*\z}

  attr_accessor :terms_accepted, :covenant_accepted, :current_password, :member_type

  has_many :access_grants, class_name: 'Doorkeeper::AccessGrant', foreign_key: :resource_owner_id, dependent: :delete_all

  has_many :access_tokens, class_name: 'Doorkeeper::AccessToken', foreign_key: :resource_owner_id, dependent: :delete_all

  has_many :transactions
  def length_of_password
    errors[:password] << "is too short (minimum is 6 characters)" if password.length < 6
  end

  def format_of_email
    validates_format_of :email, :with => Devise::email_regexp
  end

  def length_of_name_and_format
    errors[:name] << "is too short (minimum is 2 characters)" if name.length < 2
    validates_format_of :name, :with => /\A[a-z ]+\z/i, :message => "input alphabetic value only"
  end

  def generate_access_token
    access_token = Doorkeeper::AccessToken.new(
      resource_owner_id: id,
      use_refresh_token: true,
      expires_in: Doorkeeper.configuration.access_token_expires_in
    )
    return access_token if access_token.save

    access_token.errors.full_messages.first
  end

  # Define convenience methods for roles:
  # User#member?, User#alliance_admin?, User#super_admin?, etc.
  Role::NAMES.each do |name|
    role = Role.send(name)
    define_method("#{name}?") { user_roles.where(role_id: role.id).exists? }
  end

  def display_name
    name || email
  end

  def location_name
    city_name = CS.get(address_country, address_state)[(address_city.to_i)]
    country_name = JSON.parse(CS.countries.to_json)[address_country]
    "#{city_name}, #{address_state} #{address_zip}\n#{country_name}"
  end

  def update_invite_status
    if referral_code.present?
      @invite = Invite.find_by_referral_code(referral_code)
      @invite.status = 'Done'
      @invite.save
    end
  end

  def add_alliance_description
    alliance.update_attributes(name: name) if alliance.present?
  end

  def attending?(event)
    event.is_a?(Event) && event.attendees.where(user_id: id).exists?
  end

  def subscribe_user_to_mailing_list
    # SubscribeUserToMailingListJob.perform_later(email: self.email, name: self.name)
  end

  def get_roles
    # Returns role the user has in an array of strings
    roles = []

    roles.push('Super Admin') if super_admin?
    # roles.push('Alliance Admin') if alliance_admin?
    # roles.push('Business Admin') if business_admin?
    # roles.push('Church Admin')   if church_admin?
    # roles.push('City Director')  if city_director?
    # roles.push('State Director') if state_director?
    roles.push('Donor') if donor?
    roles.push('Charity Admin') if charity_admin?
    roles.push('Charity Coordinator') if charity_coordinator?
    roles.push('Member') if member?

    roles
  end

  def include_any_edit_action?(data)
    !%w[edit_alliance edit_business edit_church update].include?(data[:action]) && !(data[:controller].eql?('registrations') && data[:action].eql?('edit'))
  end

  def get_wallet_address
    if commit_good_address.present?
      commit_good_address
    elsif bitcoin_address.present?
      bitcoin_address
    elsif ethereum_address.present?
      ethereum_address
    end
  end

  def lat_lng
    [lat, lng]
  end

  def password_required?
    self.provider != 'globalid'
  end

  def user_chatrooms
    self.sender_chatrooms + self.receiver_chatrooms
  end

  def is_volunteer?(user)
    user.roles.first.name == 'volunteer'
  end

  def wallet_status
    if self.wallet_address.present? && self.wallet_address_verified == true
      return 2
    elsif self.wallet_address.present? && self.wallet_address_verified == false
      return 1
    else
      return 0
    end
  end

  private

  def current_password_match
    change = changes[:encrypted_password]
    if !change.present? || new_record? || current_password.nil?
      nil
    elsif !Devise::Encryptor.compare(User, change[0], current_password)
      errors.add(:current_password, 'does not match')
    end
  end
end
