require 'net/http'

namespace :campaing do
  desc 'send pending donation'
  task send_pending_donation: :environment do
    PendingDonation.where(payment_success: false).each do |pending_donation|
      symbol = pending_donation.symbol
      current_user = User.find_by(authorization_token: pending_donation.authorization_token)
      if symbol == 'btc'
        # API for bitcoin transaction
        address = current_user.bitcoin_address
        blockio = BlockioApiService.block_io
        prepared_txn = blockio.prepare_transaction(:amounts => pending_donation.amount.to_s, :from_addresses => address, :to_addresses => pending_donation.address)
        create_txn = blockio.create_and_sign_transaction(prepared_txn)
        send_amount_response = blockio.submit_transaction(:transaction_data => create_txn)
      elsif symbol == 'good'
        # API for ethereum transaction
        address = current_user.ethereum_address
        send_amount_response = Faraday.post("#{ENV['CRYPTO_WALLET_API_V2']}/ethereum/mainnet/addresses/#{address}/transaction-requests") do |req|
          req.headers['Content-Type'] = 'application/json'.freeze
          req['X-API-Key'] = (ENV['MY_CRYPTO_APIS_KEY']).to_s
          req.body = {
            data: {
              item: {
                amount: pending_donation.amount.to_s,
                feePriority: 'standard',
                callbackSecretKey: "testCallback",
                callbackUrl: "#{ENV['CRYPTO_APIS_CALLBACK_URL']}/transaction_callback",
                recipientAddress: pending_donation.address
              }
            }
          }.to_json
        end
      end

      unless JSON.parse(send_amount_response.body).key?('error')
        pending_donation.payment_success = true
        pending_donation.save
      end
    end
  end
end
