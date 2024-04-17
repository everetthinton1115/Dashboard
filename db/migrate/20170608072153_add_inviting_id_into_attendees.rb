class AddInvitingIdIntoAttendees < ActiveRecord::Migration[6.0]
  def change
    add_column :attendees, :inviting_id, :integer
  end
end
