class CreateWallets < ActiveRecord::Migration[6.0]
  def change
    create_table :wallets do |t|
      t.integer :user_id
      t.string :meta_address
      t.timestamps null: false
    end
  end
end
