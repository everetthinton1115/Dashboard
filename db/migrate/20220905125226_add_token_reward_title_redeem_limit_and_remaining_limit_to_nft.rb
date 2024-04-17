class AddTokenRewardTitleRedeemLimitAndRemainingLimitToNft < ActiveRecord::Migration[6.0]
  def change
    add_column :nfts, :token, :string, default: ""
    add_index :nfts, :token
    add_column :nfts, :reward_title, :string, default: ""
    add_column :nfts, :redeem_limit, :integer, default: 0
    add_column :nfts, :remaining_limit, :integer, default: 0
  end
end