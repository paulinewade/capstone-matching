FactoryBot.define do
  factory :student do
    full_name { 'John Doe' }  # Use the correct attribute name here
    email { 'john@tamu.edu' }
    password { 'password' }
  end
end
