class RenameHashToNftHash < ActiveRecord::Migration[6.0]
  def change
    rename_column :nfts, :hash, :nft_hash
  end
end
