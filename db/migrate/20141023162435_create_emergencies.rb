class CreateEmergencies < ActiveRecord::Migration
  def change
    create_table :emergencies do |t|
      t.datetime :date
      t.string :status
      t.boolean :simulacrum

      t.timestamps
    end
  end
end
