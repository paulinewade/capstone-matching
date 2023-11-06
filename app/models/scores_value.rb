class ScoresValue < ApplicationRecord
    self.primary_key = ['scores_id', 'attribute_id']
  
    belongs_to :scores_entity, foreign_key: 'scores_id', primary_key: 'scores_id'
    belongs_to :scores_attribute, foreign_key: 'attribute_id', primary_key: 'attribute_id'
  
    validates :feature_score, presence: true
  end
  