class RenameColumnTypeOfCompany < ActiveRecord::Migration
  def change
    rename_column :companies, :type, :activity
  end
end
