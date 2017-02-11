class ChangeMulticolumToTicker < ActiveRecord::Migration[5.0]
  def change
    change_column :Tickers, :best_ask, :string
    change_column :Tickers, :best_bid_size, :string
    change_column :Tickers, :best_ask_size, :string
    change_column :Tickers, :total_bid_depth, :string
    change_column :Tickers, :total_ask_depth, :string
    change_column :Tickers, :ltp, :string
    change_column :Tickers, :volume, :string
    change_column :Tickers, :volume_by_product, :string
  end
end
