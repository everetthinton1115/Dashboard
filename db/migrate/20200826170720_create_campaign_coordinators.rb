class CreateCampaignCoordinators < ActiveRecord::Migration[6.0]
  def change
    create_table :campaign_coordinators do |t|
      t.string :campaign_id
      t.string :integer
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
