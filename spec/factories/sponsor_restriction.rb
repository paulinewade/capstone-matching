FactoryBot.define do
    factory :sponsor_restriction do
      project
      restriction_type { 'gender' }
      restriction_val { 'Male' }
    end
  end
  