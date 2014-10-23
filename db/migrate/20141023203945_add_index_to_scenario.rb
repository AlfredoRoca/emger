class AddIndexToScenario < ActiveRecord::Migration
  def change
    add_index :scenarios, :name
  end
end
