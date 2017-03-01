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
    uri.query = "child_order_state=COMPLETED&parent_order_id=JCP20170226-140823-058260"

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

    result.each do |row|
      c = Child.new
      c.parent_order_id           =  row['parent_order_id']
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
  end
end
