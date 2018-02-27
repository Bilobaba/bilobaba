class ChangeNameAutorFromComments < ActiveRecord::Migration[5.1]
  def change
    rename_column :comments, :autor_id, :author_id
  end
end
