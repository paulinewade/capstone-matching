class Professor < ApplicationRecord
  self.primary_key = 'professor_id'
  
  belongs_to :user, foreign_key: 'professor_id', primary_key: 'user_id'

  has_many :courses, foreign_key: 'professor_id', primary_key: 'professor_id'
  has_many :professor_preferences, foreign_key: 'professor_id', primary_key: 'professor_id'

  validates :verified, inclusion: [true, false]
  validates :admin, inclusion: [true, false]
end

