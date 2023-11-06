class SponsorPreference < ApplicationRecord
    self.primary_key = 'preference_id'
  
    belongs_to :project, foreign_key: 'project_id', primary_key: 'project_id'
  
    validates :preference_type, presence: true, uniqueness: true
    validates :preference_val, presence: true, uniqueness: true
    validates :bonus_amount, presence: true
  end
  