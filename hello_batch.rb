class HelloBatch
  def self.execute
    puts 'hello world'
    puts Ticker.all.count
  end
end

HelloBatch.execute
