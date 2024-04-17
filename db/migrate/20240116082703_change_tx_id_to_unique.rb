class ChangeTxIdToUnique < ActiveRecord::Migration[6.0]
  def change
    change_column :transactions, :tx_id, :string, unique: true
  end
end
