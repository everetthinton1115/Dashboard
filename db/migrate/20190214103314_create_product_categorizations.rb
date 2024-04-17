class CreateProductCategorizations < ActiveRecord::Migration[6.0]
  def change
    create_table :product_categorizations do |t|
      t.references :product, index: true, foreign_key: true
      t.references :product_category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
