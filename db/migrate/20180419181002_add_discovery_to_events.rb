class AddDiscoveryToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :discovery, :integer
  end
end
