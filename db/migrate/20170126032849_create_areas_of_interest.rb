class CreateAreasOfInterest < ActiveRecord::Migration[6.0]
  def change
    create_table :areas_of_interest do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
