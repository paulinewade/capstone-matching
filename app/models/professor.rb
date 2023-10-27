class Professor < ApplicationRecord
  serialize :semester, Array
  serialize :section, Array

  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  attribute :semester, default: []
  attribute :section, default: []
  attribute :admin_approved, default: false
  attribute :admin, default: false

  has_many :professor_preferences
  has_many :preferred_projects, through: :professor_preferences, source: :project
end

