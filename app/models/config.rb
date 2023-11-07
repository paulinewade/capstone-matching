class Config < ApplicationRecord
    self.primary_key = 'config_id'

    validates :min_number, presence: true
    validates :max_number, presence: true
    validates :form_open, presence: true
    validates :form_close, presence: true
end