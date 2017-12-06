class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :content
      t.references :event, foreign_key: {to_table: :events}
      t.references :autor, foreign_key: {to_table: :members}

      t.timestamps
    end
  end
end
