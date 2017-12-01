class CreateAttendEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :attend_events do |t|
      t.references :event, foreign_key: true
      t.references :member, foreign_key: true

      t.timestamps
    end
  end
end
