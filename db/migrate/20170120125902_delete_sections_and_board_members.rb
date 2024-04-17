class DeleteSectionsAndBoardMembers < ActiveRecord::Migration[6.0]
  def change
    drop_table :sections
    drop_table :board_members
  end
end
