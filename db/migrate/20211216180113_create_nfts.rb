class CreateNfts < ActiveRecord::Migration[6.0]
    def change
      create_table :nfts do |t|
        t.string :name
        t.float :price
        t.string :description
        t.belongs_to :campaign
        
        t.timestamps
      end
    end
end