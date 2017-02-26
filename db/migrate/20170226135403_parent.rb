class Parent < ActiveRecord::Migration[5.0]
  def change
    add_column :parents, :status, :string
  end
end
