FactoryBot.define do
    factory :config do
      min_number { 1 }
      max_number { 10 }
      form_open { DateTime.now - 1.day }
      form_close { DateTime.now + 1.day }
    end
  end
  