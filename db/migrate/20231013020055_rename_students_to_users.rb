class RenameStudentsToUsers < ActiveRecord::Migration[7.0]
  def up
    rename_table :students, :users
  end

  def down
    rename_table :users, :students
  end
end
