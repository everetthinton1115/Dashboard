class AddWalletAddressAndWalletAddressVerifiledToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :wallet_address, :string, default: ""
    add_column :users, :wallet_address_verified, :boolean, default: false
  end
end
