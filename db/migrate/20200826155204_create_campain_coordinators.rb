class CreateCampainCoordinators < ActiveRecord::Migration[6.0]
  def change
    create_table :campain_coordinators do |t|
      t.integer :campaign_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
