class CreatePendingDonations < ActiveRecord::Migration[6.0]
  def change
    create_table :pending_donations do |t|
      t.string :authorization_token
      t.string :symbol
      t.string :address
      t.float :amount
      t.boolean :payment_success, default: false
      t.timestamps
    end
  end
end
