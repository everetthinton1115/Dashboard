class AddNftStatusToNfts < ActiveRecord::Migration[6.0]
  def change
    add_column :nfts, :nft_status, :string, default: "Pending"
  end
end
