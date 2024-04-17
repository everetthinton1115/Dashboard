class CreateAds < ActiveRecord::Migration[6.0]
  def change
    create_table :ads do |t|
      t.attachment :image
      t.datetime :expiration

      t.timestamps null: false
    end
  end
end
