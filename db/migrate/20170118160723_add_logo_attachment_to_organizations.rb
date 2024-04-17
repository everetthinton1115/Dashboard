class AddLogoAttachmentToOrganizations < ActiveRecord::Migration[6.0]
  def change
    remove_column :organizations, :logo, :string
    add_attachment :organizations, :logo
  end
end
