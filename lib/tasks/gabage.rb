class Tasks::Gabage
  def self.execute

    # Ticker
    Ticker.delete_all("created_at < '#{14.days.ago}'")
    # Parent
    Parent.delete_all("created_at < '#{14.days.ago}'")
    # Child
    Child.delete_all("created_at < '#{14.days.ago}'")
    # Difference
    Difference.delete_all("created_at < '#{14.days.ago}'")

  end
end

