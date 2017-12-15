class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string      :title,       null: false, default: ""
      t.string      :description, null: false, default: ""
      t.datetime    :begin
      t.datetime    :end
      t.integer     :price_min,   default: 0
      t.integer     :price_max,   default: 0
      t.integer     :members_max, default: 0
      t.string      :adress,      null: false, default: ""
      t.string      :town,        null: false, default: ""
      t.string      :zip,         null: false, default: ""
      t.float       :lat
      t.float       :lng
      t.references  :member, foreign_key: true

      t.string :encrypted_password, null: false, default: ""



      t.timestamps
    end
  end
end
