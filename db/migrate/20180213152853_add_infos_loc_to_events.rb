class AddInfosLocToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :info_location, :string
  end
end
