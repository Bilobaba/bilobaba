class CreateFollowEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :follow_events do |t|
      t.references :event, foreign_key: true
      t.references :member, foreign_key: true

      t.timestamps
    end
  end
end
