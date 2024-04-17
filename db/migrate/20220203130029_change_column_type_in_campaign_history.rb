class ChangeColumnTypeInCampaignHistory < ActiveRecord::Migration[6.0]
  def change
    change_column :campaign_check_in_histories, :tokens, :string
  end
end
