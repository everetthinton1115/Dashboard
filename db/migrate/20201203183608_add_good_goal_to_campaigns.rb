class AddGoodGoalToCampaigns < ActiveRecord::Migration[6.0]
  def change
	  add_column :campaigns, :good_goal_amount, :float, :default => 0
	  change_column :campaigns, :goal_amount, :float
  end
end
