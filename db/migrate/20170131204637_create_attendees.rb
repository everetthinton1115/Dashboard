class CreateAttendees < ActiveRecord::Migration[6.0]
  def change
    create_table :attendees do |t|
      t.integer :event_id
      t.integer :user_id
      t.integer :attendance_level_id
      t.string :email
      t.string :name

      t.timestamps null: false
    end
  end
end
