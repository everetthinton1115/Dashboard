class CreateCards < ActiveRecord::Migration[6.0]
  def change
    create_table :cards do |t|
      t.string :customer_id
      t.string :card_token
      t.integer  :user_id
      t.timestamps null: false
    end
  end
end
