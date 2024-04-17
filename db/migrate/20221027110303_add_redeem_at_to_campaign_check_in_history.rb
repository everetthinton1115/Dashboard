class AddRedeemAtToCampaignCheckInHistory < ActiveRecord::Migration[6.0]
  def change
    add_column :campaign_check_in_histories, :redeem_at, :datetime
  end
end
