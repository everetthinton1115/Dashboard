task import_users: :environment do
  filename = File.join Rails.root, "users.csv"
  CSV.foreach(filename) do |raw|
    email = raw[0]
    firstname = raw[1].present? ? (raw[1]+' '+raw[2].to_s) : nil
    user = User.new(email: email, name: firstname, password: 'Commitgood1', password_confirmation: 'Commitgood1')
    role = Role.charity_admin
    user.alliance_id = Alliance.find_by_contact_email(email).id rescue nil
    user.save
    user.roles << role
  end
end