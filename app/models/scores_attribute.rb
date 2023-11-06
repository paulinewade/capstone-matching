class ScoresAttribute < ApplicationRecord
    self.primary_key = 'attribute_id'

    has_many :scores_values, foreign_key: 'attribute_id', primary_key: 'attribute_id'

    validates :attribute_id, presence: true
    validates :feature_name, presence: true
    validates :feature_weight, presence: true
end
