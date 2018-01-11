class RenameColumnAdressMembers < ActiveRecord::Migration[5.1]
  def change
    rename_column :members, :adress, :address
  end
end
