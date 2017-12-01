class CreateFollows < ActiveRecord::Migration[5.1]
  def change
    create_table :follows do |t|
      t.references :follower, references: :members
      t.references :followee, references: :members

      t.timestamps
    end
  end
end
