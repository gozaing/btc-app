class CreateChildren < ActiveRecord::Migration[5.0]
  def change
    create_table :children do |t|
      t.string :parent_order_id
      t.string :child_order_id
      t.string :child_order_type
      t.string :side
      t.numeric :price
      t.numeric :average_price
      t.numeric :size
      t.string :child_order_state
      t.timestamp :child_order_date
      t.string :child_order_acceptance_id
      t.numeric :executed_size

      t.timestamps
    end
  end
end
