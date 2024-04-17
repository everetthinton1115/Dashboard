class AddMintIdToNfts < ActiveRecord::Migration[6.0]
  def change
    add_column :nfts, :mint_id, :string
    add_index :nfts, :mint_id

  end
end
