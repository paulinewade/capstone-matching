class Project < ApplicationRecord
  self.primary_key = 'project_id'

  belongs_to :course, foreign_key: 'course_id', primary_key: 'course_id', optional: true
  
  has_many :professor_preferences, foreign_key: 'project_id', primary_key: 'project_id'
  has_many :scores_entities, foreign_key: 'project_id', primary_key: 'project_id'
  has_many :sponsor_restrictions, foreign_key: 'project_id', primary_key: 'project_id', inverse_of: :project
  has_many :sponsor_preferences, foreign_key: 'project_id', primary_key: 'project_id', inverse_of: :project

  accepts_nested_attributes_for :sponsor_preferences, reject_if: lambda { |attributes| attributes['preference_type'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :sponsor_restrictions, reject_if: lambda { |attributes| attributes['restriction_type'].blank? }, allow_destroy: true

  validates :name, presence: true
  validates :description, presence: true
  validates :sponsor, presence: true
  validates :semester, presence: true
end
