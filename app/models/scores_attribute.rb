class ScoresAttribute < ApplicationRecord
    self.primary_key = 'attribute_id'

    has_many :scores_values, foreign_key: 'attribute_id', primary_key: 'attribute_id'
    
    validates :feature, presence: true
    validates :feature_weight, presence: true
end
