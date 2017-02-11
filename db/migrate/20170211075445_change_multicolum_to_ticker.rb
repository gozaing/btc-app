class ChangeMulticolumToTicker < ActiveRecord::Migration[5.0]
  def change
    change_column :tickers, :best_ask, :string
    change_column :tickers, :best_bid_size, :string
    change_column :tickers, :best_ask_size, :string
    change_column :tickers, :total_bid_depth, :string
    change_column :tickers, :total_ask_depth, :string
    change_column :tickers, :ltp, :string
    change_column :tickers, :volume, :string
    change_column :tickers, :volume_by_product, :string
  end
end
