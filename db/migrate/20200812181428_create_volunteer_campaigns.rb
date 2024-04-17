class CreateVolunteerCampaigns < ActiveRecord::Migration[6.0]
  def change
    create_table :volunteer_campaigns do |t|
      t.integer :volunteer_id
      t.integer :campaign_id
      t.string :status

      t.timestamps null: false
    end
  end
end
