class RenameToAddress < ActiveRecord::Migration[5.1]
  def change
    rename_column :events, :adress, :address
  end
end
