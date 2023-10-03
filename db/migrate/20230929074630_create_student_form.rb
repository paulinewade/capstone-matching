class CreateStudentForm < ActiveRecord::Migration[7.0]
  def change
    create_table :student_forms do |t|
      t.string :email
      t.string :last_name
      t.string :first_name
      t.integer :uin

      t.timestamps
    end
  end
end