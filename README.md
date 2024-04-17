# Important Versions
- Ruby: `2.6.3`
- Rails: `6.0.3`

# Setup dependencies
1. You need postgresSQL running on your machine (https://www.postgresql.org/download/)
1. Setup RVM or equivalent for ruby version management. Install ruby version 2.6.3

# Setup Application
1. Clone the repo: `git clone https://github.com/everetthinton1115/dashboard.git`
1. Create a .env file in the outermost directory `touch ~/dashboard/.env`. Below I will paste a blank env copy. You will need Heroku credentials to get some of the actual values.
1. Set RVM to use the correct ruby version: `rvm use ruby-2.6.3`. To prevent doing this everytime you can also create a file with the version at the outermost directory next to your `.env` file. `touch ~/dashboard/.ruby-version` then `echo "ruby-2.6.3" >> ~/dashboard/.ruby-version`.
1. Install the bundler `gem install bundler -v 1.3.0`
1. Run the bundler to install all gems needed: `bundle install`.
2.If error related to mimemagic, run this command `bundle update --conservative mimemagic`.

# Setup Database
1. Create your db and seed it: `rake db:setup`
1. Run migrations: `rake db:migrate`

# Run Application
- `rails s` 

# Deployment instructions
- Deployments are done through heroku.. `git push heroku master`

---

## Example .env File
```
POSTGRES_USER='postgres'
POSTGRES_PASSWORD=''
POSTGRES_HOST='localhost'
POSTGRES_DB='commit_good_development'
POSTGRES_PORT: 5432

AWS_ACCESS_KEY='**'
AWS_REGION='**'
AWS_SECRET='**'
CAMPAIGN_IMAGE_BUCKET='**'
USER_PROFILE_BUCKET='**'

HOST_URL='localhost:3000/'

SENDGRID_API_KEY='**'
```
