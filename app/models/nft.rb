class Nft < ApplicationRecord
    default_scope { order('id') }

    belongs_to :campaign
    belongs_to :user
    has_many :images, as: :imageable, dependent: :destroy

    validates :title, :price,
              :redeem_limit, presence: true

    # validates :mint_id, presence: true, on: :update

    has_attached_file :image,
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
    validates_attachment_content_type :image, content_type: %r{\Aimage/.*\z}

    scope :not_pending, -> { where.not(nft_status: "Pending")}
    scope :not_purchased, -> { where.not(nft_status: "Purchased")}

    before_create do
        self.token = generate_token
        self.remaining_limit = self.redeem_limit
    end

    after_create do
        if self.nft_status == "Created"
            ApplicationMailer.nft_is_purchased(self).deliver_later
            ApplicationMailer.nft_is_sold(self).deliver_later
        end
    end

    def generate_token
        loop do
            token = SecureRandom.hex(8)
            break token unless Nft.where(token: token).exists?
        end
    end
end
