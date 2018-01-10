class RenameBeginEndTown < ActiveRecord::Migration[5.1]
  def change
    rename_column :events, :begin, :begin_at
    rename_column :events, :end, :end_at
    rename_column :events, :town, :city
  end
end
