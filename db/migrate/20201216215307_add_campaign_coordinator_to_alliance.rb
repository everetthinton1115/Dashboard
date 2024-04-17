class AddCampaignCoordinatorToAlliance < ActiveRecord::Migration[6.0]
  def change
	  add_column :alliances, :campaign_coordinator_id, :integer
  end
end
