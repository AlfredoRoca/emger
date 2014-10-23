class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.string :description
      t.string :coord_x
      t.string :coord_y

      t.timestamps
    end
  end
end
