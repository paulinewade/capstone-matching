FactoryBot.define do
    factory :professor do
      email { 'example@tamu.edu' }
      first_name { 'John' }
      last_name { 'Doe' }
      admin_approved {false}
      admin {false}
    end
  end
  