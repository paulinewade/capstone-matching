FactoryBot.define do
    factory :user do
      email { 'test_user@tamu.edu' }
      first_name { 'John' }
      last_name { 'Doe' }
      role { 'student' }
    end
  end
  