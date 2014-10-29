class AddEmergencyToFollowup < ActiveRecord::Migration
  def change
    add_reference :followups, :emergency, index: true
  end
end
