class AddFacebookUrlAndLinkedinUrlAndWebsiteUrlToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :facebook_url, :string
    add_column :users, :linkedin_url, :string
    add_column :users, :website_url, :string
  end
end
