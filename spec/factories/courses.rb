FactoryBot.define do
  sequence(:section) { |n| n }
    factory :course do
      course_number { 101 }
      section {generate(:section)}
      semester { 'Fall 2023' }
    end
  end
  