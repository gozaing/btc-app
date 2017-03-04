class Tasks::Log
  def self.execute
    require "net/http"
    require "uri"
    require "openssl"
    require "json"

    key    = ENV['BITFLYER_API_KEY']
    secret = ENV['BITFLYER_API_TOKEN']

    timestamp = Time.now.to_i.to_s
    nowstr    = (Time.now - 3.hours).strftime('%Y/%m/%d %H:%M:%S')
    method = "GET"
    parents = Parent.where("parent_order_id is not null and status = 'ACTIVE' and created_at < '#{nowstr}'").limit(10)
    parents.each do |parent|

      parent_order_id = parent.parent_order_id
      uri = URI.parse(ENV['BITFLYER_API_URI'])
      uri.path = "/v1/me/getchildorders"
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

      res.each do |row|
        c = Child.new
        c.parent_order_id           = "#{parent_order_id}"
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

      # get trade log buy and sell
      buy_child = Child.where("parent_order_id='#{parent_order_id}' and side='BUY'").first
      buy_child_order_id = buy_child.child_order_id
      buy_price          = buy_child.average_price

      sell_child = Child.where("parent_order_id='#{parent_order_id}' and side='SELL'").first
      sell_child_order_id = sell_child.child_order_id
      sell_price          = sell_child.average_price

      # set result of trade
      logger = Logger.new(Rails.root.join('log', "#{Rails.env}.log"))
      begin
        r = Result.new
        r.parent_order_id      = parent_order_id
        r.buy_child_order_id   = buy_child_order_id
        r.buy_price            = buy_price
        r.sell_child_order_id  = sell_child_order_id
        r.sell_price           = sell_price
        r.diff                 = buy_price - sell_price
        r.save
      rescue => e
        logger.error("Unhandled exception! #{e} : #{e.backtrace.inject(result = "") { |result, stack| result += "from:#{stack}\n" }}")
      end

      # parent status change 
      parent.status = "COMPLETED"
      parent.save
    end
  end
end
