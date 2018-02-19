class RenameInfoLocationToNote < ActiveRecord::Migration[5.1]
  def change
    rename_column :events, :info_location, :note
  end
end
