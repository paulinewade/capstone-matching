class Project < ApplicationRecord
  validates :Name, presence: true
  validates :Description, presence: true
  validates :Semester, presence: true
  has_many :professor_preferences
  has_many :professors_who_prefer, through: :professor_preferences, source: :professor
end
