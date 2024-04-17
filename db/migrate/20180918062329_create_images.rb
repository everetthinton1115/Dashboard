class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.string :campaign_id
      t.attachment :image
      t.timestamps null: false
    end
  end
end
