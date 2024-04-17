class AddLimitToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :limit, :integer, default: 2
  end
end
