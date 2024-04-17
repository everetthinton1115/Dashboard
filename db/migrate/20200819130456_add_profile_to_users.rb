class AddProfileToUsers < ActiveRecord::Migration[6.0]
  def change
    add_attachment :users, :profile
    add_column :users, :lat, :float
    add_column :users, :lng, :float
  end
end
