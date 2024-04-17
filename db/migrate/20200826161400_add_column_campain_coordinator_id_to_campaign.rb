class AddColumnCampainCoordinatorIdToCampaign < ActiveRecord::Migration[6.0]
  def change
    add_column :campaigns, :campain_coordinator_id, :integer
  end
end
