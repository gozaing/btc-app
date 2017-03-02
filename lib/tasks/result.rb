class Tasks::Result
  def self.execute
    require "net/http"
    require "uri"
    require "openssl"
    require "json"

    key    = ENV['BITFLYER_API_KEY']
    secret = ENV['BITFLYER_API_TOKEN']

    timestamp = Time.now.to_i.to_s
    method = "GET"
    uri = URI.parse(ENV['BITFLYER_API_URI'])
    uri.path = "/v1/me/getchildorders"
    # TODO get parent_order_id from Parent model
    parent_order_id = "JCP20170226-140823-058260"
    uri.query = "child_order_state=COMPLETED&parent_order_id=#{parent_order_id}"

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
    res      = JSON.parse(response.body)
    p res

    res.each do |row|
      c = Child.new
      c.parent_order_id           = '#{parent_order_id}'
      c.child_order_id            = row['child_order_id']
      c.child_order_type          = row['child_order_type']
      c.side                      = row['side']
      c.price                     = row['price']
      c.average_price             = row['average_price']
      c.size                      = row['size']
      c.child_order_state         = row['child_order_state']
      c.child_order_date          = row['child_order_date']
      c.child_order_acceptance_id = row['child_order_acceptance_id']
      c.executed_size             = row['executed_size']
      c.save
    end
=begin
    p 'start trade log'
    # get trade log buy and sell
    buy_child = Child.where("parent_order_id='#{parent_order_id}' and side='BUY'")
    buy_child_order_id = buy_child.child_order_id
    p buy_child_order_id
    buy_price          = buy_child.average_price
    p buy_price

    sell_child = Child.where("parent_order_id='#{parent_order_id}' and side='SELL'")
    sell_child_order_id = sell_child.child_order_id
    sell_price          = sell_child.average_price

    # set result of trade
    result = Result.new
    result.parent_order_id      = parent_order_id
    result.buy_child_order_id   = buy_child_order_id
    result.buy_price            = buy_price
    result.sell_child_order_id  = sell_child_order_id
    result.sell_price           = sell_price
    result.diff                 = buy_price - sell_price
    result.save
=end

  end
end
