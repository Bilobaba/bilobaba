class RenameColumnTownCityMembers < ActiveRecord::Migration[5.1]
  def change
    rename_column :members, :town, :city
  end
end
