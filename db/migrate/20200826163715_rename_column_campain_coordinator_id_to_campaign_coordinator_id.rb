class RenameColumnCampainCoordinatorIdToCampaignCoordinatorId < ActiveRecord::Migration[6.0]
  def change
    rename_column :campaigns, :campain_coordinator_id, :campaign_coordinator_id
  end
end
