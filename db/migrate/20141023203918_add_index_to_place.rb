class AddIndexToPlace < ActiveRecord::Migration
  def change
    add_index :places, :name
  end
end
