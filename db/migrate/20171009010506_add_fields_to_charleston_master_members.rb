class AddFieldsToCharlestonMasterMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :charleston_master_members, :date_added, :datetime
    add_column :charleston_master_members, :last_changed, :datetime
  end
end
