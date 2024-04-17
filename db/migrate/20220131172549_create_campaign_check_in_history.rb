class CreateCampaignCheckInHistory < ActiveRecord::Migration[6.0]
  def change
    create_table :campaign_check_in_histories do |t|
      t.integer :campaign_id
      t.integer :user_id
      t.boolean :checked_in
      t.datetime :last_checked_in
      t.integer :tokens
      t.string :total_hours
    end
  end
end
