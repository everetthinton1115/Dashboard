class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :tx_id
      t.float :amount_in_good
      t.float :amount_in_usd
      t.string :title
      t.references :campaign, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
