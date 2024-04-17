class AddApprovedToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :approved, :boolean, default: false
  end
end
