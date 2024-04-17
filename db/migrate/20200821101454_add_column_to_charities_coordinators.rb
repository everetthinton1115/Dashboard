class AddColumnToCharitiesCoordinators < ActiveRecord::Migration[6.0]
  def change
    add_column :charities_coordinators, :user_id, :integer
  end
end
