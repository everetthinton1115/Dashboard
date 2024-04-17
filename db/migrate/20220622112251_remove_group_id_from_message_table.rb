class RemoveGroupIdFromMessageTable < ActiveRecord::Migration[6.0]
  def change
    remove_column :messages, :group_id, :string
  end
end
