ActiveAdmin.register Campaign do

  permit_params :name, :description, :user, :goal_amount, :address_city, :address_state, :address_country,
                :address_zip, :expiration_date

  filter :name
  filter :user

  index do
    selectable_column
    id_column
    column "Admin", :user
    column :campaign_coordinator_id, as: "Coordinator" do |coordinator|
      User.find_by(id: coordinator.campaign_coordinator_id).try(:name)
    end
    column :name
    column :description
    column :goal_amount
    column :address_city
    column :address_state
    column :address_country
    column :address_zip
    column :expiration_date
    column :created_at
    actions
  end

  show do
    attributes_table do
      row "Admin", :user do |coordinator|
        User.find_by(id: coordinator.user_id).try(:name)
      end
      row :campaign_coordinator_id, as: "Coordinator" do |coordinator|
        User.find_by(id: coordinator.campaign_coordinator_id).try(:name)
      end
      row :name
      row :description
      row :goal_amount
      row :address_city
      row :address_state
      row :address_country
      row :address_zip
      row :expiration_date
      row :created_at
      row "Images" do |campaign|
        ul do
          campaign.images.each do |c_image|
            li do
              image_tag(c_image.image.url(:medium))
            end
          end
        end
      end
      panel "GOOD Gig Activities" do
        table_for campaign.volunteers do |v|
          column :title
          column :description
          column "Number of GOOD Gig needed", :hours
          column "Total number of Hours", :number
        end
      end

      panel "NFT's" do
        table_for campaign.nfts do
          column :title
          column :price
          column :image do |resource|
            ul do
              resource.images.each do |c_image|
                li do
                  image_tag(c_image.image.url(:medium))
                end
              end
            end
          end

          # nft.images.each | nft |
          #   image_tage(nft.image.url(:medium))
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :user
      # f.input :goal_amount
      f.input :address_city
      f.input :address_state
      f.input :address_country, :as => :string
      f.input :address_zip
      f.input :expiration_date
    end
    f.actions
  end

end