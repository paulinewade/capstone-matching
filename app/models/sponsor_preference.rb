class SponsorPreference < ApplicationRecord
    self.primary_key = 'preference_id'
  
    belongs_to :project, foreign_key: 'project_id', primary_key: 'project_id'
  
    validates :project_id, presence: true
    validates :preference_type, presence: true
    validates :preference_val, presence: true
    validates :bonus_amount, presence: true
  end
  