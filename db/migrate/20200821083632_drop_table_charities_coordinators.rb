class DropTableCharitiesCoordinators < ActiveRecord::Migration[6.0]
  def change
	table_exists?(:charities_coordinators) ? drop_table(:charities_coordinators) : nil
  end
end
