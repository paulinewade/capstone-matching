FactoryBot.define do
    sequence :user_email do |n|
      "test_user#{n}@tamu.edu"
    end
    factory :user do
      email { generate(:user_email)}
      first_name { 'John' }
      last_name { 'Doe' }
      role { 'student' }
    end
  end
  