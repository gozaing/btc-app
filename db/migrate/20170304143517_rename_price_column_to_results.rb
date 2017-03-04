class RenamePriceColumnToResults < ActiveRecord::Migration[5.0]
  def change
    rename_column :results, :sel_price, :sell_price
  end
end
