class AddImagecloudyToEvents < ActiveRecord::Migration[5.1]
  def change
    add_reference :events, :cloudy
  end
end
