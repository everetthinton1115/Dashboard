class AddNftTypeToNfts < ActiveRecord::Migration[6.0]
  def change
    add_column :nfts, :nft_type, :string
    add_index :nfts, :nft_type
  end
end
