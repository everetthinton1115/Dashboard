class AddPaidToVolunteerApplier < ActiveRecord::Migration[6.0]
  def change
    add_column :volunteer_appliers, :paid, :boolean, default: false
  end
end
