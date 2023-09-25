class Project < ApplicationRecord
  validates :Name, presence: true
  validates :Description, presence: true
  validates :Semester, presence: true
end
