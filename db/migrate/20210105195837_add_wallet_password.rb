class AddWalletPassword < ActiveRecord::Migration[6.0]
  def change
	  add_column :users, :wallet_password, :string
  end
end
