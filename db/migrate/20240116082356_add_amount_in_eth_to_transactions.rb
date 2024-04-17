class AddAmountInEthToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :amount_in_eth, :float
  end
end
