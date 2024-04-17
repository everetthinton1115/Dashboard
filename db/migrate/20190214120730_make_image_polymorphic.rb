class MakeImagePolymorphic < ActiveRecord::Migration[6.0]
  def change
    add_reference :images, :imageable, polymorphic: true
  end
end
