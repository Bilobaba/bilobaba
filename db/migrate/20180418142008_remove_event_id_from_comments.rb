class RemoveEventIdFromComments < ActiveRecord::Migration[5.1]
  def change
    remove_reference :comments, :event, foreign_key: true
  end
end
