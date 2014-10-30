class CreateNotificationRelations < ActiveRecord::Migration
  def change
    create_table :notification_relations do |t|
      t.integer :person_id
      t.integer :place_id

      t.timestamps
    end
  end
end
