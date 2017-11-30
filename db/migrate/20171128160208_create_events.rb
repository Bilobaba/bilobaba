class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string      :title
      t.string      :description
      t.datetime    :begin
      t.datetime    :end
      t.integer     :price_min
      t.integer     :price_max
      t.string      :adress
      t.string      :town
      t.string      :zip
      t.float       :lat
      t.float       :lng
      t.references  :member, foreign_key: true

      t.timestamps
    end
  end
end
