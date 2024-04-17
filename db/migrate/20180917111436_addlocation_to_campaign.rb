class AddlocationToCampaign < ActiveRecord::Migration[6.0]
  def change
    add_column :campaigns, :address_city, :string
    add_column :campaigns, :address_state, :string
    add_column :campaigns, :address_country, :string
    add_column :campaigns, :address_zip, :string
  end
end
