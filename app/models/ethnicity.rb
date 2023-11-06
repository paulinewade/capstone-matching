class Ethnicity < ApplicationRecord
    self.table_name = 'ethnicities'
    self.primary_key = 'ethnicity_name'

    has_many :ethnicity_values, foreign_key: 'ethnicity_name', primary_key: 'ethnicity_name'
end