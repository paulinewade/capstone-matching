class Ethnicity < ApplicationRecord
    self.table = 'ethnicities'
    self.primary_key = 'ethnicity_name'

    has_many :ethnicity_values, foreign_key: 'ethnicity_name', primary_key: 'ethnicity_name'

    validates :ethnicity_name, presence: true
end