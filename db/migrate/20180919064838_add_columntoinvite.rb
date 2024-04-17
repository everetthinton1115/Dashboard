class AddColumntoinvite < ActiveRecord::Migration[6.0]
  def change
    add_column :invites, :user_id, :integer
    add_column :invites, :referral_code, :string
  end
end
