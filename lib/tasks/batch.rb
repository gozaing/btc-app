class Tasks::Batch
  def self.execute
    require 'net/http'
    require 'uri'

    uri = URI.parse("https://api.bitflyer.jp")
    uri.path = '/v1/board'
    uri.query = ''

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    response = https.get uri.request_uri
    puts response.body
  end
end
