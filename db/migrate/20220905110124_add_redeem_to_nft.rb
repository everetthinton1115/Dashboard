class AddRedeemToNft < ActiveRecord::Migration[6.0]
  def change
    add_column :nfts, :redeem, :boolean, default: false
  end
end
