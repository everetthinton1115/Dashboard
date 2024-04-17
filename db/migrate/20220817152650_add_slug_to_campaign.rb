class AddSlugToCampaign < ActiveRecord::Migration[6.0]
  def change
    add_column :campaigns, :slug, :string
    add_index :campaigns, :slug, unique: true
  end
end
