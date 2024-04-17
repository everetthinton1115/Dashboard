class AddUuidToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :uuid, :string, default: ""
    add_column :users, :provider, :string, default: "gmail"
  end
end
