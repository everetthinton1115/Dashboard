class AddStripeInfoToAds < ActiveRecord::Migration[6.0]
  def change
    add_column :ads, :charge_id, :string
    add_column :ads, :card_token, :string
    add_column :ads, :url, :string
  end
end
