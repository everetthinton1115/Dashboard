class ChangeNameToTitleInNft < ActiveRecord::Migration[6.0]
  def change
    rename_column :nfts, :name, :title
  end
end
