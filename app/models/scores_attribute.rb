class ScoresAttribute < ApplicationRecord
    validates :attribute_id, presence: true
    validates :feature_name, presence: true
    validates :feature_weight, presence: true
end
