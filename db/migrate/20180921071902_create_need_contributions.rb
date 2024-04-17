class CreateNeedContributions < ActiveRecord::Migration[6.0]
  def change
    create_table :need_contributions do |t|
      t.integer :user_id
      t.integer :need_id
      t.integer :campaign_id
      t.string :status
      t.string :drop_off_date
      t.timestamps null: false
    end
  end
end
