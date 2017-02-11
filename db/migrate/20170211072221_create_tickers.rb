class CreateTickers < ActiveRecord::Migration[5.0]
  def change
    create_table :tickers do |t|
      t.integer :tick_id
      t.decimal :best_bid
      t.decimal :best_ask
      t.decimal :best_bid_size
      t.decimal :best_ask_size
      t.decimal :total_bid_depth
      t.decimal :total_ask_depth
      t.decimal :ltp
      t.decimal :volume
      t.decimal :volume_by_product

      t.timestamps
    end
  end
end
