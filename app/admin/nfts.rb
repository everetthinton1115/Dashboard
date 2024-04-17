ActiveAdmin.register Nft do
  config.filters = false
  actions :index, :show

  index do
    selectable_column
    id_column
    column :campaign
    column :user
    column :title
    column :description
    column :price
    column :image do |nft|
      image_tag(nft.image.url)
    end
    actions
  end

  show do
    attributes_table do

      row :campaign
      row :user
      row :title
      row :description
      row :price
      row :image do |nft|
        image_tag(nft.image.url)
      end
    end
  end

end
