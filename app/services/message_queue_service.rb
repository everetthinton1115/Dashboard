class MessageQueueService

  class << self
    
    def append_message(sig, data)
      
      client = Azure::Storage::Queue::QueueService.create(
        storage_account_name: ENV['AZURE_STORAGE_ACCOUNT_NAME'],
        storage_access_key: ENV['AZURE_STORAGE_ACCESS_KEY']
      )

      data = JSON.parse(data)

      message = {
        sig: sig,
        data: data,
        eventType: data['primaryType']
      }

      sevenDaysInSeconds = 604800;
      options = { message_ttl: sevenDaysInSeconds, encode: true }
      
      client.create_message("signedtransactions", message.to_json, options)
    end

  end

end
