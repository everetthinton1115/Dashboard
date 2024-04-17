# frozen_string_literal: true

require 'block_io'
# Block.io api is used for bitcoin functionality
class BlockioApiService
  KEY = (ENV['BLOCKIO_BTC_API_KEY']).to_s    # Key of Block.io API
  PIN = (ENV['BLOCKIO_BTC_API_PIN']).to_s    # Pin of Block.io API

  private_constant :KEY, :PIN

  def self.block_io
    block_io_obj
  end

  # This Proxy URL is of QuotaGurad Add On to Make Heroku IP static.
  # returns the URI of Outbound Proxy URL.
  def self.proxy_url
    # URI(ENV["QUOTAGUARDSTATIC_URL"])
  end

  # This Proxy URL is of QuotaGurad Add On to Make Heroku IP static.
  # returns the URI of Outbound Proxy URL.
  def self.block_io_obj
    BlockIo::Client.new(:api_key => KEY, :pin => PIN, :proxy => {
        hostname: proxy_url.try(:host),
        port: proxy_url.try(:port),
        username: proxy_url.try(:user),
        password: proxy_url.try(:password)
      }
    )
  end

  private_class_method :block_io_obj, :proxy_url
end
