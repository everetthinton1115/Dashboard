class CreateProductCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :product_categories do |t|
      t.string :name
      t.boolean :active

      t.timestamps null: false
    end
  end
end
