class Project < ApplicationRecord
  self.primary_key = 'project_id'

  belongs_to :course, foreign_key: 'course_id', primary_key: 'course_id', optional: true
  
  has_many :professor_preferences, foreign_key: 'project_id', primary_key: 'project_id'
  has_many :scores_entities, foreign_key: 'project_id', primary_key: 'project_id'
  has_many :sponsor_restrictions, foreign_key: 'project_id', primary_key: 'project_id'
  has_many :sponsor_preferences, foreign_key: 'project_id', primary_key: 'project_id'

  validates :name, presence: true
  validates :description, presence: true
  validates :sponsor, presence: true
end
