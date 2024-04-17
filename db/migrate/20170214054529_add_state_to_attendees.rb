class AddStateToAttendees < ActiveRecord::Migration[6.0]
  def change
    add_column :attendees, :paid, :boolean, :default => false
    add_column :attendees, :charge_id, :string
    add_column :attendees, :card_token, :string
  end
end
