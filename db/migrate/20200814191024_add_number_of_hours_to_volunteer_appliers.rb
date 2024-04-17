class AddNumberOfHoursToVolunteerAppliers < ActiveRecord::Migration[6.0]
  def change
    add_column :volunteer_appliers, :number_of_hours, :integer
  end
end
