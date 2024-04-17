class AddRegistrationLinkToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :registration_url, :string
  end
end
