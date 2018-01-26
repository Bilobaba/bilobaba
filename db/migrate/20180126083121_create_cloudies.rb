class CreateCloudies < ActiveRecord::Migration[5.1]
  def change
    create_table :cloudies do |t|
      t.string :identifier

      t.timestamps
    end
  end
end
