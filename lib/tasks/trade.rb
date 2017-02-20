class Tasks::Trade
  def self.execute

    require "net/http"
    require "uri"
    require "openssl"

    key = ENV['BITFLYER_API_KEY']
    secret = ENV['BITFLYER_API_TOKEN']

    timestamp = Time.now.to_i.to_s
    method = "POST"
    api_url = ENV['BITFLYER_API_URI']
    uri = URI.parse(api_url)
    uri.path = "/v1/me/sendchildorder"
    body ='
      {
        "product_code": "BTC_JPY",
        "child_order_type": "MARKET",
        "side": "BUY",
        "size": 0.001,
        "minute_to_expire": 525600,
        "time_in_force": "GTC"
    }'
    text = timestamp + method + uri.request_uri + body
    sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)

    options = Net::HTTP::Post.new(uri.request_uri, initheader = {
      "ACCESS-KEY" => key,
      "ACCESS-TIMESTAMP" => timestamp,
      "ACCESS-SIGN" => sign,
      "Content-Type" => "application/json"
    });
    options.body = body

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    response = https.request(options)
    puts response.body
  end
end
