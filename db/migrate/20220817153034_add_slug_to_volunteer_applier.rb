class AddSlugToVolunteerApplier < ActiveRecord::Migration[6.0]
  def change
    add_column :volunteer_appliers, :slug, :string
    add_index :volunteer_appliers, :slug, unique: true
  end
end
