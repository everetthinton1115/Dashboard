class AddColumnInterestTypeToAreaOfInterest < ActiveRecord::Migration[6.0]
  def change
    add_column :areas_of_interest, :interest_type, :string
  end
end
