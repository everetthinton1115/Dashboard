class CreateUserChatrooms < ActiveRecord::Migration[6.0]
  def change
    create_table :user_chatrooms do |t|
      t.integer :chatroom_id
      t.integer :user_id

      t.timestamps
    end
  end
end
