class ChangeColumnToTicker < ActiveRecord::Migration[5.0]
  def change
    change_column :tickers, :best_bid, :string
  end
end
