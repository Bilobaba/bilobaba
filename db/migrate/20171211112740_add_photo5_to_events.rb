class AddPhoto5ToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :photo5, :string
  end
end
