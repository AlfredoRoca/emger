class AddPlaceToEmergency < ActiveRecord::Migration
  def change
    add_reference :emergencies, :place, index: true
  end
end
