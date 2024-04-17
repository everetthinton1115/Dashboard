class CreateUploadImages < ActiveRecord::Migration[6.0]
  def change
    create_table :upload_images do |t|
      t.attachment :image
      t.timestamps
    end
  end
end
