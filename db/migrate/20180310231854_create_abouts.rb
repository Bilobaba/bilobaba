class CreateAbouts < ActiveRecord::Migration[5.1]
  def change
    create_table :abouts do |t|
      t.references :testimonial, foreign_key: true
      t.references :member, foreign_key: true

      t.timestamps
    end
  end
end
