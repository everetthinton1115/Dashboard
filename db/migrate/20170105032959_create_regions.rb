class CreateRegions < ActiveRecord::Migration[6.0]
  def change
    create_table :regions do |t|
      t.string :name
      t.string :lonlat, geographic: true

      t.timestamps null: false
    end
  end
end
