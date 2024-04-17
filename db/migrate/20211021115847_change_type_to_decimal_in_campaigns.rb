class ChangeTypeToDecimalInCampaigns < ActiveRecord::Migration[6.0]
  def up
    change_column :campaigns, :goal_amount, :decimal, :precision => 15, :scale => 8
    change_column :campaigns, :total_amount, :decimal, :precision => 15, :scale => 8
  end

  def down
    change_column :campaigns, :goal_amount, :float
    change_column :campaigns, :total_amount, :integer
  end
end
