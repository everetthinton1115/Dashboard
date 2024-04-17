class Invite < ApplicationRecord
  belongs_to :user

  before_save :set_referral_code

  def set_referral_code
    referral_code = SecureRandom.hex(5)
    while Invite.find_by_referral_code(referral_code).present? do
      referral_code = SecureRandom.hex(5)
    end
    self.referral_code = referral_code
  end
end