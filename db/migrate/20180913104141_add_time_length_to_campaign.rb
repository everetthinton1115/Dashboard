class AddTimeLengthToCampaign < ActiveRecord::Migration[6.0]
  def change
    add_column :campaigns, :time_length, :integer
  end
end
