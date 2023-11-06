class Course < ApplicationRecord
    self.primary_key = 'course_id'

    belongs_to :professor, foreign_key: 'professor_id', primary_key: 'professor_id'
    has_many :projects, foreign_key: 'course_id', primary_key: 'course_id'
    has_many :students, foreign_key: 'course_id', primary_key: 'course_id'

    validates :course_number, presence: true
    validates :section, presence: true
    validates :semester, presence: true
end
  