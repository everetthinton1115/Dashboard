ActiveAdmin.register User do
  permit_params do
    permitted = [:email, :name, :address_line1, :address_line2, :address_city, :address_state, :address_country,
                 :address_zip]
  end

  filter :email
  filter :name

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :address_line1
    column :address_line2
    column :address_city
    column :address_state
    column :address_zip
    column :created_at
    column :wallet_address
    column :role do |user|
      role = user.roles.first.try(:name)
      if role
        if role == "nft"
          role = "Entrepreneur"
        elsif role == "charity_admin"
          role = "Charity"

        elsif role == "charity_coordinator"
          role = "Charity Coordinator"
        end
      elsif role == "volunteer"
        role = "$GOOD Gig"
      elsif role == "donor"
        role = "Patron"
      end
      role
    end

    actions
  end

  form do |f|
    f.inputs 'Details' do
      f.input :email
      f.input :name
      f.input :address_line1
      f.input :address_line2
      f.input :address_city
      f.input :address_state
      f.input :address_zip
    end
    f.actions
  end

  show do
    attributes_table do
      row :email
      row :name
      row :address_line1
      row :address_line2
      row :address_city
      row :address_state
      row :address_zip
    end
  end

end
