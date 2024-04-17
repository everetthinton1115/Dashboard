class AddHashToNfts < ActiveRecord::Migration[6.0]
  def change
    add_column :nfts, :hash, :string
  end
end
