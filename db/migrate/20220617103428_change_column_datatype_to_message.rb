class ChangeColumnDatatypeToMessage < ActiveRecord::Migration[6.0]
  def change
    change_column :messages, :message, :text
  end
end
