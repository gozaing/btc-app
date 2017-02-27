class Tasks::Trade
  def self.execute

    require "net/http"
    require "uri"
    require "openssl"

    key    = ENV['BITFLYER_API_KEY']
    secret = ENV['BITFLYER_API_TOKEN']

    timestamp = Time.now.to_i.to_s
    method = "POST"
    uri = URI.parse(ENV['BITFLYER_API_URI'])
    uri.path = "/v1/me/sendparentorder"

    last_ltp = Difference.last.ltp.to_i
    ltp_high = (last_ltp + (last_ltp * 0.003)).floor
    ltp_low  = (last_ltp - (last_ltp * 0.003)).floor
    ltp_sell = (ltp_low  - (ltp_low  * 0.003)).floor

    body = '{
      "order_method": "IFDOCO",
      "time_in_force": "GTC",
      "parameters": [{
        "product_code": "BTC_JPY",
        "condition_type": "MARKET",
        "side": "BUY",
        "size": 0.01
      },
      {
      "product_code": "BTC_JPY",
      "condition_type": "LIMIT",
      "side": "SELL",
      "price": ' + ltp_high.to_s + ',
      "size": 0.01
      },
      {
      "product_code": "BTC_JPY",
      "condition_type": "STOP_LIMIT",
      "side": "SELL",
      "price": ' + ltp_sell.to_s + ',
      "trigger_price": ' + ltp_low.to_s + ',
      "size": 0.01
      }]
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

    # Todo: use json parse
    str = response.body.match("parent_order_acceptance_id\":\"(.+)\"}")

    parent_id = self.get_parent(str[1])

    p = Parent.new
    p.parent_order_id            = parent_id
    p.parent_order_acceptance_id = str[1]
    p.status = "ACTIVE"
    p.save

  end

  def self.get_parent(accept_id)

    require "net/http"
    require "uri"
    require "openssl"
    require "json"

    key    = ENV['BITFLYER_API_KEY']
    secret = ENV['BITFLYER_API_TOKEN']

    timestamp = Time.now.to_i.to_s
    method = "GET"
    uri = URI.parse(ENV['BITFLYER_API_URI'])
    uri.path = "/v1/me/getparentorder"
    uri.query = "parent_order_acceptance_id=" + accept_id

    text = timestamp + method + uri.request_uri
    sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)

    options = Net::HTTP::Get.new(uri.request_uri, initheader = {
      "ACCESS-KEY" => key,
      "ACCESS-TIMESTAMP" => timestamp,
      "ACCESS-SIGN" => sign,
    });

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    response = https.request(options)

    result = JSON.parse(response.body)
    result["parent_order_id"]

  end
end
