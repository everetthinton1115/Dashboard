class AddUserAndRegionToAds < ActiveRecord::Migration[6.0]
  def change
    add_column :ads, :region_id, :integer
    add_column :ads, :user_id, :integer

    add_index :ads, :region_id
    add_index :ads, :user_id
  end
end
