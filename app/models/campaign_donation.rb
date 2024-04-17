require 'net/http'

class CampaignDonation < ApplicationRecord
  belongs_to :campaign
  belongs_to :user

  validates :donation_amount, numericality: { greater_than: 0 }, presence: true

  def self.send_transaction(wallet_address, symbol, other_wallet_address, amount)
    transaction_protocol = symbol == 'btc' ? 'bitcoin' : 'ethereum'

    if transaction_protocol == 'bitcoin'
      # for bitcoin transactions
      blockio = BlockioApiService.block_io
      begin
        wallet_address_valid = blockio.is_valid_address(:address => wallet_address)['data']['is_valid'] || false
        other_wallet_address_valid = blockio.is_valid_address(:address => other_wallet_address)['data']['is_valid'] || false
        if wallet_address_valid && other_wallet_address_valid
          # Truncate amount to 8 decimal digits - acceptable limit set by block.io
          # Amount must be specified as a string.
          prepared_txn = blockio.prepare_transaction(:amounts => BigDecimal(amount.to_s).truncate(8).to_s('F'), :from_addresses => wallet_address, :to_addresses => other_wallet_address)
          create_txn = blockio.create_and_sign_transaction(prepared_txn)
          send_amount_response = blockio.submit_transaction(:transaction_data => create_txn)
        else
          send_amount_response = {'status' => "failure", 'error' => 'Address is invalid'}
        end
      rescue BlockIo::APIException => e
        # error when unable to access API
        send_amount_response = {'status' => "failure", 'error' => e}
      end
    else
      # for ethereum/good transactions
      send_amount_response = Faraday.post(api_for_ethereum_transaction(wallet_address)) do |req|
        req.headers['Content-Type'] = 'application/json'.freeze
        req['X-API-Key'] = (ENV['MY_CRYPTO_APIS_KEY']).to_s
        req.body = {
          data: {
            item: {
              amount: amount.to_s,
              feePriority: 'standard',
              callbackSecretKey: "testCallback",
              callbackUrl: "#{ENV['CRYPTO_APIS_CALLBACK_URL']}/transaction_callback",
              recipientAddress: other_wallet_address
            }
          }
        }.to_json
      end
    end
    return send_amount_response
  end

  def self.api_for_ethereum_transaction(wallet_address)
    "#{ENV['CRYPTO_WALLET_API_V2']}/ethereum/mainnet/addresses/#{wallet_address}/transaction-requests"
  end

  private_class_method :api_for_ethereum_transaction
end
