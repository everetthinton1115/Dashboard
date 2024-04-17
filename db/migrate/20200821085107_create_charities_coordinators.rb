class CreateCharitiesCoordinators < ActiveRecord::Migration[6.0]
  def change
    create_table :charities_coordinators do |t|
      t.integer :charitable_id
      t.string :charitable_type

      t.timestamps null: false
    end
  end
end
