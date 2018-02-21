class AddFacebookIdToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :facebook_id, :string
  end
end
