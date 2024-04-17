class AddTotalFieldForGoodAmount < ActiveRecord::Migration[6.0]
  def change
	  add_column :campaigns, :total_good_amount, :float, :default => 0
  end
end
