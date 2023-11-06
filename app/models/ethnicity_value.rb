class EthnicityValue < ApplicationRecord
    self.primary_key = 'ethnicity_value_id'
  
    belongs_to :student, foreign_key: 'student_id', primary_key: 'student_id'
    belongs_to :ethnicity, foreign_key: 'ethnicity_name', primary_key: 'ethnicity_name'
  
    validates :student_id, presence: true
    validates :ethnicity_name, presence: true
  end