class AddChatroomIdInMessageTable < ActiveRecord::Migration[6.0]
  def change
    add_reference :messages, :chatroom, index: true
  end
end
