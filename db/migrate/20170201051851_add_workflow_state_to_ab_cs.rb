class AddWorkflowStateToAbCs < ActiveRecord::Migration[6.0]
  def change
    add_column :alliances, :approval_state, :string, :default => "new"
    add_column :churches, :approval_state, :string, :default => "new"
  end
end
