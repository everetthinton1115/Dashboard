class CreateInvites < ActiveRecord::Migration[6.0]
  def change
    create_table :invites do |t|
      t.string :sender_email
      t.string :receiver_email
      t.string :subject
      t.string :body
      t.string :status
      t.timestamps null: false
    end
  end
end
