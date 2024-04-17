class AddRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :name

      t.timestamps null: false
    end

    reversible do |dir|
      dir.up do
		%w(member charity_admin donor church_admin super_admin business_admin alliance_admin city_director state_director vendor charity_coordinator).each_with_index do |name, i|
	      Role.find_or_create_by name: name
	    end
      end
    end
  end
end
