class AddStateToAds < ActiveRecord::Migration[6.0]
  def change
    add_column :ads, :approval_state, :string, :default => "new"
  end
end
