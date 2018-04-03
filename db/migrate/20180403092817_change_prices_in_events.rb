class ChangePricesInEvents < ActiveRecord::Migration[5.1]
  def change
    change_column_default :events, :price_max, from: 0, to: nil
    change_column_default :events, :price_min, from: 0, to: nil
  end
end
