class AddExpirationToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :expiration, :datetime
  end
end
