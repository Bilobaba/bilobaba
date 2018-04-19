class AddTicketsToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :tickets, :integer
  end
end
