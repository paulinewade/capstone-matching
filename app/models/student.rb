class Student < ApplicationRecord
  self.primary_key = 'student_id'

  has_many :ethnicity_values, foreign_key: 'student_id', primary_key: 'student_id'
  has_many :scores_entities, foreign_key: 'student_id', primary_key: 'student_id'
  belongs_to :user, foreign_key: 'student_id', primary_key: 'user_id'
  belongs_to :course, foreign_key: 'course_id', primary_key: 'course_id'

  validates :gender, presence: true
  validates :nationality, presence: true
  validates :work_auth, presence: true
  validates :contract_sign, presence: true
end
