class AddUserIdToNfts < ActiveRecord::Migration[6.0]
  def change
    add_column :nfts, :user_id, :integer
  end
end
