class CreateChatrooms < ActiveRecord::Migration[6.0]
  def change
    create_table :chatrooms do |t|
      t.string :name
      t.string :Role
      t.boolean :group_chat, :default => false

      t.timestamps
    end
  end
end
