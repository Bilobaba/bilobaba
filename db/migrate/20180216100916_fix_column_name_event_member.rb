class FixColumnNameEventMember < ActiveRecord::Migration[5.1]
  def change
        rename_column :events, :member_id, :organizer_id
  end
end
