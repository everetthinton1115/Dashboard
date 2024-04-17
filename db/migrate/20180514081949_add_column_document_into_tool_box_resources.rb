class AddColumnDocumentIntoToolBoxResources < ActiveRecord::Migration[6.0]
  def change
    add_attachment :tool_box_resources, :document
  end
end
