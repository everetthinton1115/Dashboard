class Organization < ActiveRecord::Base; end

class RenameAffiliatesToAlliances < ActiveRecord::Migration[6.0]
  def up
    Organization.where(type: 'Affiliate').update_all(type: 'Alliance')
  end

  def down
    Organization.where(type: 'Alliance').update_all(type: 'Affiliate')
  end
end
