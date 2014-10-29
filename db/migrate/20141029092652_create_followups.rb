class CreateFollowups < ActiveRecord::Migration
  def change
    create_table :followups do |t|
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
