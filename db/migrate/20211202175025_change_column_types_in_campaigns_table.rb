class ChangeColumnTypesInCampaignsTable < ActiveRecord::Migration[6.0]
  def change
    change_column :campaigns, :good_goal_amount, :text
    change_column :campaigns, :goal_amount, :text
  end

  def down
    change_column :campaigns, :good_goal_amount, :float
    change_column :campaigns, :goal_amount, :integer
  end
end
