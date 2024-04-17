class AreaOfInterest < ApplicationRecord

  scope :for_vendors, -> { where 'interest_type = ?', 'Vendor' }
  scope :for_charities, -> { where 'interest_type = ?', 'Charity' }

end
