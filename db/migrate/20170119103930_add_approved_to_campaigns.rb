class AddApprovedToCampaigns < ActiveRecord::Migration[6.0]
  def change
    add_column :campaigns, :approved, :boolean
  end
end
