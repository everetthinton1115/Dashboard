class CreateDonations < ActiveRecord::Migration[6.0]
  def change
    create_table :donations do |t|
      t.string :request_id
      t.string :donation_amount
      t.string :sender_address
      t.string :receiver_address
      t.string :transaction_request_id
      t.string :transaction_request_status

      t.timestamps
    end
  end
end
