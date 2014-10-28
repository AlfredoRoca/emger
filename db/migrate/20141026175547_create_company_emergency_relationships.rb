class CreateCompanyEmergencyRelationships < ActiveRecord::Migration
  def change
    create_table :company_emergency_relationships do |t|
      t.integer :company_id
      t.integer :emergency_id

      t.timestamps
    end
  end
end
