class CreateVolunteerContributions < ActiveRecord::Migration[6.0]
  def change
    create_table :volunteer_contributions do |t|
      t.datetime :sign_in
      t.datetime :sign_out
      t.integer :volunteer_id
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
