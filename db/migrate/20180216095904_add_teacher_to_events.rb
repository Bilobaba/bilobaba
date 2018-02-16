class AddTeacherToEvents < ActiveRecord::Migration[5.1]
  def change
    add_reference :events, :teacher, foreign_key: {to_table: :members}
  end
end
