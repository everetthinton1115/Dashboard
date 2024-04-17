class AddSelfieAndDriverLicenseToUsers < ActiveRecord::Migration[6.0]
    def up
        add_attachment :users, :identification_photo
        add_attachment :users, :license_photo
    end

    def down
        remove_attachment :users, :identification_photo
        remove_attachment :users, :license_photo
    end
end
