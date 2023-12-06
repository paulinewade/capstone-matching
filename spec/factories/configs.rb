FactoryBot.define do
    factory :config do
      min_number { 1 }
      max_number { 10 }
      form_open { DateTime.now - 1.day }
      form_close { DateTime.now + 1.day }
      fall_semester_day {15}
      fall_semester_month {8}
      spring_semester_day {15}
      spring_semester_month {1}
      summer_semester_day {1}
      summer_semester_month {6}
    end
  end
  