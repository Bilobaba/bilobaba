class CreateCalendars < ActiveRecord::Migration[5.1]
  def change
    create_table :calendars do |t|
      t.datetime :begin_at
      t.datetime :end_at
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
