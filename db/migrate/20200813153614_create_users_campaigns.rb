class CreateUsersCampaigns < ActiveRecord::Migration[6.0]
  def change
    create_table :users_campaigns do |t|
      t.integer :user_id
      t.integer :campaign_id
      t.string :status

      t.timestamps null: false
    end
  end
end
