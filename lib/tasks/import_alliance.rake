task import_alliance: :environment do
  filename = File.join Rails.root, "organizations.csv"
  CSV.foreach(filename) do |raw|
    firstname = raw[0]
    description = raw[1]
    twitter_url = raw[2]
    facebook_url = raw[3]
    contact_email = raw[4]
    website_url = raw[5]
    
 
    alliance = Alliance.new(name: firstname, description: description, twitter_url: twitter_url, facebook_url: facebook_url, contact_email: contact_email,website_url: website_url)
    alliance.save
  end
end