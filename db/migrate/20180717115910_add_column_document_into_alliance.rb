class AddColumnDocumentIntoAlliance < ActiveRecord::Migration[6.0]
  def change
    add_attachment :alliances, :verification_doc
  end
end
