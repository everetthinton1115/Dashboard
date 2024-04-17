class AddDefaultValueOfFacebookUrlToUser < ActiveRecord::Migration[6.0]
  def up
    change_column :users, :facebook_url, :string, default: ""
    change_column :users, :linkedin_url, :string, default: ""
    change_column :users, :website_url, :string, default: ""
  end

  def down
    change_column :users, :facebook_url, :string
    change_column :users, :linkedin_url, :string
    change_column :users, :website_url, :string
  end
end
