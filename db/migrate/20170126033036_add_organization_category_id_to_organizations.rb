class AddOrganizationCategoryIdToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :organization_category_id, :integer
  end
end
