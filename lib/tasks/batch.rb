class Tasks::Batch
  def self.execute
    require 'net/http'
    require 'uri'
    require 'json'

    env_uri   = ENV['BITFLYER_API_URI']
    uri       = URI.parse(env_uri)
    uri.path  = '/v1/ticker'
    uri.query = ''

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    response = https.get uri.request_uri
    result   = JSON.parse(response.body)

    current_ltp = result['ltp'].to_i
    last_ltp    = Ticker.last.ltp.to_i
    diff_ltp    = current_ltp - last_ltp

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

    diff = Difference.new
    diff.diff_id   = ticker.tick_id
    diff.ltp       = result['ltp'].to_i
    diff.diff      = diff_ltp
    diff.save

    # bid timing check
    hash = ActiveRecord::Base.connection.select_all(
      "select sum(sub1.diff) diff from (select diff from differences order by created_at desc limit 5) sub1").to_hash
    evaluate_ltp = hash[0]["diff"]
    if evaluate_ltp > 100 then
      p "go bid"
      # execute bid task
      #Tasks::Trade.execute
    end

  end
end
