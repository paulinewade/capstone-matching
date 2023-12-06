class Config < ApplicationRecord
    self.primary_key = 'config_id'

    validates :min_number, presence: true
    validates :max_number, presence: true
    validates :form_open, presence: true
    validates :form_close, presence: true
    validates :fall_semester_month, presence: true
    validates :spring_semester_month, presence: true
    validates :summer_semester_month, presence: true
    validates :fall_semester_day, presence: true
    validates :spring_semester_day, presence: true
    validates :summer_semester_day, presence: true
end