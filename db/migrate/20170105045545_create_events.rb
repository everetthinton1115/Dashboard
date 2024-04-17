class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.attachment :image
      t.datetime :start
      t.datetime :end
      t.integer :region_id

      t.timestamps null: false
    end
  end
end
