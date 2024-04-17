class AddRegionToCampaigns < ActiveRecord::Migration[6.0]
  def change
    add_column :campaigns, :region_id, :integer
  end
end
