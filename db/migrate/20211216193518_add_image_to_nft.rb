class AddImageToNft < ActiveRecord::Migration[6.0]
    def change
      add_attachment :nfts, :image
    end
end