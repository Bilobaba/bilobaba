class AddCalendarRangeStringToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :calendar_range_string, :string
  end
end
