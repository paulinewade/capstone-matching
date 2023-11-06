class ScoresEntity < ApplicationRecord
    self.table_name = 'scores_entities'
    self.primary_key = 'scores_id'
  
    belongs_to :student, foreign_key: 'student_id', primary_key: 'student_id'
    belongs_to :project, foreign_key: 'project_id', primary_key: 'project_id'
    has_many :scores_values, foreign_key: 'score_id', primary_key: 'score_id'

    validates :student_id, presence: true
    validates :project_id, presence: true
    validates :pref, presence: true
  end
  