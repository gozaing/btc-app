class Tasks::Batch
  def self.execute
    require 'net/http'
    require 'uri'
    require 'json'

    uri = URI.parse(Settings.bitflyer[:api_path])
    #uri.path = '/v1/board'
    uri.path = '/v1/ticker'
    uri.query = ''

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    response = https.get uri.request_uri
    result = JSON.parse(response.body)

    ticker = Ticker.new
    ticker.tick_id              = result['tick_id']
    ticker.best_bid             = result['best_bid']
    ticker.best_ask             = result['best_ask']
    ticker.best_bid_size        = result['best_bid_size']
    ticker.best_ask_size        = result['best_ask_size']
    ticker.total_bid_depth      = result['total_bid_depth']
    ticker.total_ask_depth      = result['total_ask_depth']
    ticker.ltp                  = result['ltp']
    ticker.volume               = result['volume']
    ticker.volume_by_product    = result['volume_by_product']
    ticker.save

  end
end
