class AddGroupIdToMessage < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :group_id, :integer
    rename_column :messages, :text, :message
  end
end
