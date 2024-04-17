class ChangeFloatTypeToDecimalInCampaignDonations < ActiveRecord::Migration[6.0]
  def up
    change_column :campaign_donations, :donation_amount, :decimal, :precision => 15, :scale => 8
  end

  def down
    change_column :campaign_donations, :donation_amount, :float
  end
end
