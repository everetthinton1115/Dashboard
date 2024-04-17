class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string   "name"
      t.text     "description"
      t.integer  "user_id"
      t.integer  "price"
      t.integer  "region_id"
      t.string   "address_city"
      t.string   "address_state"
      t.string   "address_country"
      t.string   "address_zip"

      t.timestamps null: false
    end
  end
end
