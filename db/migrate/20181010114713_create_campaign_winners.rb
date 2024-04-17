class CreateCampaignWinners < ActiveRecord::Migration[6.0]
  def change
    create_table :campaign_winners do |t|
      t.integer :votes
      t.integer :campaign_id
      t.integer :user_id
      t.date :winnig_month
      t.timestamps null: false
    end
  end
end
