class CreateVolunteerAppliers < ActiveRecord::Migration[6.0]
  def change
    create_table :volunteer_appliers do |t|
      t.integer :user_id
      t.integer :volunteer_id
      t.integer :campaign_id
      t.string :status
      t.timestamps null: false
    end
  end
end
