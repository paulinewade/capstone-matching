class ProfessorPreference < ApplicationRecord
    self.primary_key = 'professor_preference_id'
  
    belongs_to :professor, foreign_key: 'professor_id', primary_key: 'professor_id'
    belongs_to :project, foreign_key: 'project_id', primary_key: 'project_id'

    validates :pref, presence: true
  end
