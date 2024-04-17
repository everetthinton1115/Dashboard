class CreateJobLeads < ActiveRecord::Migration[6.0]
  def change
    create_table :job_leads do |t|
      t.string :name
      t.string :email
      t.string :profession_title
      t.references :user
      t.attachment :resume

      t.timestamps null: false
    end
  end
end
