class User < ApplicationRecord
  self.primary_key = 'user_id'
  has_one :professor, foreign_key: 'professor_id'
  has_one :student, foreign_key: 'student_id', primary_key: 'user_id'
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role, presence: true
  validates :email, presence: true, uniqueness: true   
end
