class CreateAboutCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :about_categories do |t|
      t.string :name
      t.integer :position

      t.timestamps null: false
    end
  end
end
