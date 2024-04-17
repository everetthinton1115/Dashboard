class AddShippingBooleanToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :shipping_label_printed, :boolean, :default => false
  end
end
