class SponsorRestriction < ApplicationRecord
    self.primary_key = 'restriction_id'
  
    belongs_to :project, foreign_key: 'project_id', primary_key: 'project_id'

    validates :project_id, presence: true
    validates :restriction_type, presence: true
    validates :restriction_val, presence: true
  end
  