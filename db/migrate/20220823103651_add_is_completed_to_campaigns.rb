class AddIsCompletedToCampaigns < ActiveRecord::Migration[6.0]
  def change
    add_column :campaigns, :is_completed, :boolean, default: false
  end
end
