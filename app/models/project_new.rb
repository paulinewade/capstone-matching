# app/models/project_new.rb

class ProjectNew < ApplicationRecord
  # Model attributes
  # Make sure the attributes match your schema
  self.table_name = "projects_new"
  validates :project_id, presence: true
  validates :project_name, presence: true
  validates :description, presence: true
  validates :sponsor, presence: true
  validates :class_id, presence: true

  # Associations (if you have any)
  # Example:
  # belongs_to :user
end
