class AddPhoto14ToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :photo1, :string
    add_column :events, :photo2, :string
    add_column :events, :photo3, :string
    add_column :events, :photo4, :string
  end
end
