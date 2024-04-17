class CreateNftFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :nft_files do |t|
      t.json :link

      t.timestamps
    end
  end
end
