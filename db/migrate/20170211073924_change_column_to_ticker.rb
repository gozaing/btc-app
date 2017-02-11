class ChangeColumnToTicker < ActiveRecord::Migration[5.0]
  def change
    change_column :Tickers, :best_bid, :string
  end
end
