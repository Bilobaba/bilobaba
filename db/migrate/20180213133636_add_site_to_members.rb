class AddSiteToMembers < ActiveRecord::Migration[5.1]
  def change
        add_column :members, :site, :string
        add_column :members, :gender, :string
  end
end
