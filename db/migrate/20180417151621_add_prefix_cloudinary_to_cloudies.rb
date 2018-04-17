class AddPrefixCloudinaryToCloudies < ActiveRecord::Migration[5.1]
  def change
    add_column :cloudies, :prefix_cloudinary, :string
  end
end
