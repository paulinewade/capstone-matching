class Course < ApplicationRecord
    self.table_name = "courses"

    validates :course_id, presence: true
    validates :section_number, presence: true
    validates :semester, presence: true
  end
  