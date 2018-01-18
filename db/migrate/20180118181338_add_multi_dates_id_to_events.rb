class AddMultiDatesIdToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :multi_dates_id, :datetime
  end
end
