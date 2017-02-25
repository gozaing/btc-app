class CreateParents < ActiveRecord::Migration[5.0]
  def change
    create_table :parents do |t|
      t.string :parent_order_id
      t.string :parent_order_acceptance_id

      t.timestamps
    end
  end
end
