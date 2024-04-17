class ChangeGoalAmountFromTextToDecimal < ActiveRecord::Migration[6.0]
  def change
    change_column :campaigns, :goal_amount, :decimal,  using: 'goal_amount::decimal'
  end
end
