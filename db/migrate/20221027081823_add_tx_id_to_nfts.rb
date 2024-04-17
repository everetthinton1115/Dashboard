class AddTxIdToNfts < ActiveRecord::Migration[6.0]
  def change
    add_column :nfts, :tx_id, :string
  end
end
