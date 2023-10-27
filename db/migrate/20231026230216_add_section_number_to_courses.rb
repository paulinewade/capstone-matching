class AddSectionNumberToCourses < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :section_number, :integer
    add_index :courses, [:course_id, :section_number], unique: true
  end
end
