include ActionView::Helpers::DateHelper

class Campaign < ApplicationRecord
  belongs_to :user
  has_many :campaign_donations
  has_many :needs
  has_many :videos, dependent: :destroy
  has_many :volunteers, dependent: :destroy
  has_many :images, as: :imageable, dependent: :destroy
  has_many :volunteer_appliers, dependent: :destroy
  has_many :need_contributions
  has_many :resources, through: :needs
  has_many :campaign_categorizations, dependent: :destroy
  has_many :campaign_categories, through: :campaign_categorizations
  has_many :votes, as: :voteable, dependent: :destroy
  has_many :campaign_winners
  has_many :users_campaigns, dependent: :destroy
  has_many :nfts, dependent: :destroy
  has_many :transactions
  # extend FriendlyId
  # friendly_id :name, use: :slugged
  belongs_to :campaign_coordinator, optional: true
  scope :open, -> { where(workflow_state: :open) }
  scope :successful, -> { where(workflow_state: :successful) }
  scope :approved, -> { where(approved: :true) }

  validates :name, :description, :expiration_date,
            :address_country, :address_city, :address_state, presence: true

  validates :time_length, :goal_amount, presence: true, :numericality => { greater_than: 0 }
  validate :expiration_date_cannot_be_in_the_past

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
  # accepts_nested_attributes_for :images
  # accepts_nested_attributes_for :needs, allow_destroy: true
  # accepts_nested_attributes_for :volunteers, allow_destroy: true

  before_create :cal_expiration_date

  TIMEFRAME = [[30,'30 Days'], [60,'60 Days'], [90,'90 Days']]

  def s3_url(style = nil, expires_in = 30.minutes)
    image.s3_object(style).url_for(:read, :secure => true, :expires => expires_in).to_s
  end

  def update_total_fund(amount)
    if goal_amount == total_amount
      self.workflow_state = "successful"
    else
      self.total_amount = (total_amount.nil? ? 0 : total_amount)  + (amount/100)
    end
  end

  def percent_complete
    return 0 if total_amount.blank? 
    100 * total_amount.to_f / goal_amount
  end

  def good_percent_complete
    return 0 if total_amount.blank?
    100 * total_amount.to_f / goal_amount
  end

  def days_left
    [(expiration_date - Date.today).to_i, 0].max rescue 0
  end

  def age_in_words
    distance_of_time_in_words(Time.now, self.created_at)
  end

  def get_image_url url,path
    domain = url.gsub(path,'')
    return domain.concat(image.url)
  end

  def total_donations
    self.campaign_donations.count
  end

  def cal_expiration_date
    self.expiration_date = (Date.today + (self.time_length&.days || 0)) unless self.id.present?
  end

  def is_fund_raiser?
    goal_amount.to_f > 0
  end

  # def is_volunteer?
  #   volunteers.present?
  # end

  def is_in_kind_donation?
    needs.present?
  end

  def expiration_date_cannot_be_in_the_past
    if expiration_date.present? && expiration_date < Date.today
      errors.add(:expiration_date, "can't be in the past")
    end
  end

  def self.get_server_bitcoin_balance(bit_address)
    blockio = BlockioApiService.block_io
    begin
      btc_address_response = blockio.get_address_balance :addresses => bit_address
    rescue BlockIo::APIException => e
      btc_address_response = {'status' => "failure"}
    rescue Exception => e
      btc_address_response = {'status' => "failure", 'error' => e}
    end
    return btc_address_response
  end

  def self.get_server_ethereum_balance(eth_address)
    eth_address_response = Faraday.get("#{ENV['CRYPTO_REST_API_V2']}/blockchain-data/ethereum/mainnet/addresses/#{eth_address}") do |req|
        req.headers['Content-Type'] = 'application/json'
        req["X-API-Key"] = "#{ENV['MY_CRYPTO_APIS_KEY']}"
    end
    return eth_address_response
  end

  def self.get_eth_transaction_fee
    eth_fee = Faraday.get("https://rest.cryptoapis.io/v2/blockchain-data/ethereum/mainnet/mempool/fees") do |req|
      req.headers['Content-Type'] = 'application/json'
      req["X-API-Key"] = "#{ENV['MY_CRYPTO_APIS_KEY']}"
    end
    eth_txn_fee = JSON.parse(eth_fee.body)['data']['item']
    eth_txn_fee.tap { |hs| hs.delete("unit") }
    eth_usd = self.spot_price('ETH-USD')
    return eth_txn_fee.map{|data| [data[0], BigDecimal((data[1].to_f*eth_usd*0.000000000000000001).to_s).truncate(2).to_f]}
  end

  def self.get_btc_fee_balance
    # API returns values in satoshis per byte
    fee_balance = Faraday.get("#{ENV['BITCOIN_TRANSACTION_FEE_URL']}") do |req|
      req.headers['Content-Type'] = 'application/json'
    end
    fee = []
    if fee_balance.success?
      # btc_usd returns current value of BTC in USD
      btc_usd = self.spot_price('BTC-USD')
      # 1 satoshi = 0.00000001 BTC
      # data[1]*0.00000001 gives the bitcoin fee for transaction
      # data[1] gives satoshis for the type of transaction
      fee = JSON.parse(fee_balance.body).map{|data| [data[0], BigDecimal((data[1]*0.00000001*btc_usd).to_s).truncate(2).to_f]}
    else
      fee = []
    end
    return fee
  end

  def self.get_eth_fee_balance
    # API returns values in gas price in x10 Gwei
    fee_balance = Faraday.get("#{ENV['ETH_TRANSACTION_FEE_URL']}?api-key=#{ENV['ETH_TRANSACTION_FEE_TOKEN']}") do |req|
        req.headers['Content-Type'] = 'application/json'
    end
    fee = []
    if fee_balance.success?
      eth_usd = self.spot_price('ETH-USD')
      fee << ["fastest", BigDecimal((JSON.parse(fee_balance.body)['fastest']*0.000000001*eth_usd).to_s).truncate(2).to_f]
      fee << ["fast", BigDecimal((JSON.parse(fee_balance.body)['fast']*0.000000001*eth_usd).to_s).truncate(2).to_f]
      fee << ["safeLow", BigDecimal((JSON.parse(fee_balance.body)['safeLow']*0.000000001*eth_usd).to_s).truncate(2).to_f]
      fee << ["average", BigDecimal((JSON.parse(fee_balance.body)['average']*0.000000001*eth_usd).to_s).truncate(2).to_f]
    else
      fee = []
    end  
    return fee
  end

  def self.spot_price convert
    currency_conversion = Faraday.get("https://cex.io/api/last_price/#{convert.split('-')[0]}/USD") do |req|
      req.headers['Content-Type'] = 'application/json'
    end
    JSON.parse(currency_conversion.body)['lprice'].to_f
  end

  def self.api_values(campaign, user_id)
    {
      "id": campaign.id,
      "name": campaign.name,
      "description": campaign.description,
      "user_id": campaign.user_id,
      "goal_amount": campaign.goal_amount,
      "total_amount": campaign.total_amount,
      "expiration_date": campaign.expiration_date,
      "image_alt": campaign.name,
      "image": campaign.images.present? ? campaign.images.first.try(:image): "",
      "workflow_state": campaign.workflow_state,
      "campaign_category_id": campaign.campaign_category_id,
      "category": campaign.category,
      "video_link": campaign.video_link,
      "approved": campaign.approved,
      "region_id": campaign.region_id,
      "time_length": campaign.time_length,
      "address_city": campaign.address_city,
      "address_state": campaign.address_state,
      "address_country": campaign.address_country,
      "address_zip": campaign.address_zip,
      "campaign_coordinator_id": campaign.campaign_coordinator_id,
      "good_goal_amount": campaign.good_goal_amount,
      "total_good_amount": campaign.total_good_amount,
      "check_in": check_in_against_campaign(campaign.id, user_id)
    }
  end

  def lat_lng
    lat = Geocoder.search(CS.cities(address_state, address_country)[address_city.to_i])
    @coords = lat.first.coordinates
    
    [ @coords[0], @coords[1] ]
  end
  
  def self.distance_between_two_locations(location1, location2)
    lat1,lng1 = location1
    lat2,lng2 = location2
    
    loc1 = [lat1,lng1]
    loc2 = [lat2,lng2]
    
    calculate_distance(loc1, loc2).round(2)
  end
  
  def check_in(user_id)

    if already_checkin(user_id).present?
      { 
        data: "invalid", 
        reason: "you are already checkin for this project"
      }

    elsif already_checkout(user_id).present?
      campaign_history = already_checkout(user_id)
      render_json_for_checkin if campaign_history.update_attributes({ checked_in: true, last_checked_in: Time.now })

    else
      campaign_history = CampaignCheckInHistory.create(campaign_id: self.id, user_id: user_id, checked_in: true, last_checked_in: Time.now, tokens: 0, total_hours: 0)
      render_json_for_checkin if campaign_history.present?
    end

  end
  
  def check_out(user_id)
    if already_checkout(user_id).present?
      { 
        data: "invalid", 
        reason: "you are already checkout for this project"
      }
    elsif campaign_exist?(user_id)
      campaign_history = already_checkin(user_id)
      campaign_history.assign_tokens
      
      campaign_history.update_attributes({
        checked_in: false,
        last_checked_in: nil,
      })

      return {
        data: "valid",
        reason: "checkout successful"
      }
    else
      return {
        data: "invalid",
        reason: "You need to checkin for this project"
      }
    end

  end

  private
  def self.calculate_distance(loc1, loc2)
    
    rad_per_deg = Math::PI/180  # PI / 180
    rkm         = 6371          # Earth radius in kilometers
    rm          = rkm * 1000    # Radius in meters
    
    dlat_rad    = (loc2[0].to_f - loc1[0].to_f) * rad_per_deg # Delta, converted to rad
    dlon_rad    = (loc2[1].to_f - loc1[1].to_f) * rad_per_deg
  
    lat1_rad    = loc1.map {|i| i * rad_per_deg }.reject {|e| e.to_s.empty? }.first
    lat2_rad    = loc2.map {|i| i * rad_per_deg }.reject {|e| e.to_s.empty? }.first

    lat1_rad ||= 0
    lat2_rad ||= 0
    
    a           = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c           = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
  
    rm * c # Delta in meters
  end
  
  def campaign_exist?(user_id)
    CampaignCheckInHistory.where(campaign_id: self.id, user_id: user_id).count > 0
  end

  def already_checkin(user_id)
    CampaignCheckInHistory.where(campaign_id: self.id, user_id: user_id, checked_in: true).first
  end

  def already_checkout(user_id)
    CampaignCheckInHistory.where(campaign_id: self.id, user_id: user_id, checked_in: false).first
  end

  def self.check_in_against_campaign(campaign_id, user_id)
    CampaignCheckInHistory.where(campaign_id: campaign_id, user_id: user_id).first.try(:checked_in) || false
  end

  def render_json_for_checkin
    {
      data: "valid", 
      reason: "you can checkin"
    }
  end
end
