class DropTableCampainCoordinators < ActiveRecord::Migration[6.0]
  def change
    drop_table :campain_coordinators
  end
end
