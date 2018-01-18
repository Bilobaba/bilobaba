class AddCalendarStringToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :calendar_string, :string
  end
end
