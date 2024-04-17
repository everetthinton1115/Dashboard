json.message "success"
json.success true

json.wallet_addresses do
  json.charity_cordinator_wallet_address @campaign_coordinator_wallet_address
  json.charity_admin_wallet_address @campaign.user.wallet_address
end