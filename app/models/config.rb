class Config < ApplicationRecord
    before_validation :set_defaults

    self.primary_key = 'config_id'

    validates :min_number, presence: true
    validates :max_number, presence: true
    validates :lock, presence: true

    def set_defaults
        self.min_number = 0
        self.max_number = 1
        self.lock = false
    end
end