class CreateVolunteers < ActiveRecord::Migration[6.0]
  def change
    create_table :volunteers do |t|
      t.string  :title
      t.text    :description
      t.integer :campaign_id
      t.integer :hours
      t.integer :number
      t.timestamps null: false
    end
  end
end
