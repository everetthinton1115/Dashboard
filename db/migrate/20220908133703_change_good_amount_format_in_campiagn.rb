class ChangeGoodAmountFormatInCampiagn < ActiveRecord::Migration[6.0]
    def up
      change_column :campaigns, :goal_amount, :float
    end

    def down
      change_column :campaigns, :goal_amount, :decimal
    end
end
