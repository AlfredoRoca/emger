class AddCompanyToPerson < ActiveRecord::Migration
  def change
    add_reference :people, :company, index: true
  end
end
