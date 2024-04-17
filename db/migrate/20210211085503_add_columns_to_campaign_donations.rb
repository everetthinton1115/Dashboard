class AddColumnsToCampaignDonations < ActiveRecord::Migration[6.0]
  def change
  	add_column :campaign_donations, :charity_amount, :float
    add_column :campaign_donations, :charity_coordinator_amount, :float
    add_column :campaign_donations, :status, :string
    add_column :campaign_donations, :symbol, :string
    add_column :campaign_donations, :campaign_coordinator_id, :integer
    add_column :campaign_donations, :charity_id, :integer
    change_column(:campaign_donations, :donation_amount, :float)
  end
end
