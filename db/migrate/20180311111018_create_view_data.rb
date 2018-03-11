class CreateViewData < ActiveRecord::Migration[5.1]
  def change
    create_table :view_data do |t|
      t.string :type
      t.text :content

      t.timestamps
    end
  end
end
