class CreateDifferences < ActiveRecord::Migration[5.0]
  def change
    create_table :differences do |t|
      t.integer :diff_id
      t.numeric :ltp
      t.numeric :diff

      t.timestamps
    end
  end
end
