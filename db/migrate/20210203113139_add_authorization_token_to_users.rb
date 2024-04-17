class AddAuthorizationTokenToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :authorization_token, :string
    add_column :users, :bitcoin_address, :string
    add_column :users, :commit_good_address, :string
    add_column :users, :ethereum_address, :string
  end
end
