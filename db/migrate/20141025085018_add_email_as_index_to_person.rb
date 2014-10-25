class AddEmailAsIndexToPerson < ActiveRecord::Migration
  def change
    add_index :people, :email
    remove_index :people, :name
  end
end
