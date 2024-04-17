class CreateCampaignCategorizations < ActiveRecord::Migration[6.0]
  def change
    create_table :campaign_categorizations do |t|
      t.integer :campaign_id
      t.integer :campaign_category_id

      t.timestamps null: false
    end
  end
end
