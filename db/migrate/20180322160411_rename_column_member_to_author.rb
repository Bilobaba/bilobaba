class RenameColumnMemberToAuthor < ActiveRecord::Migration[5.1]
  def change
        rename_column :testimonials, :member_id, :author_id
  end
end
