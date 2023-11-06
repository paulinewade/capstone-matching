class ScoresValue < ApplicationRecord
    self.primary_key = 'scores_value_id'
  
    belongs_to :scores_entity, foreign_key: 'scores_id', primary_key: 'scores_id'
    belongs_to :scores_attribute, foreign_key: 'attribute_id', primary_key: 'attribute_id'

    validates :scores_id, presence: true
    validates :attribute_id, presence: true
    validates :feature_score, presence: true
  end
  