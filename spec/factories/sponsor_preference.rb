FactoryBot.define do
    factory :sponsor_preference do
      project
      preference_type { 'gender' }
      preference_val { 'Female' }
      bonus_amount { 10 }
    end
  end
  