class AddPlaceNameToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :place_name, :string
  end
end
