class CreateBoardMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :board_members do |t|
      t.string :name
      t.string :title
      t.attachment :photo
      t.text :bio
      t.integer :sort_order

      t.timestamps null: false
    end
  end
end
