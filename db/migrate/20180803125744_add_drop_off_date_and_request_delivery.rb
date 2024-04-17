class AddDropOffDateAndRequestDelivery < ActiveRecord::Migration[6.0]
  def change
  	add_column :resources, :drop_off_date, :datetime
    add_column :resources, :requires_delivery, :boolean, default: false
  end
end
