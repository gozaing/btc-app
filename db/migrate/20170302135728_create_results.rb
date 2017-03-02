class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.string :parent_order_id
      t.string :buy_child_order_id
      t.numeric :buy_price
      t.string :sell_child_order_id
      t.numeric :sel_price
      t.numeric :diff

      t.timestamps
    end
  end
end
