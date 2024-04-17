class AddCreatedByToNfts < ActiveRecord::Migration[6.0]
  def change
    add_column :nfts, :created_by, :string
  end
end
