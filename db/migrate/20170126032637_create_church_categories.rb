class CreateChurchCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :church_categories do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
