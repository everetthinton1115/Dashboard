# It would run 2:00 AM on the 1st of every month.
every '0 2 1 * *' do
  rake "campaing:campaign_winner"
end