FactoryBot.define do
    factory :project do
      sequence(:name) { |n| "Project #{n}" }
      description { 'Project description' }
      sponsor { 'Project sponsor' }
      semester { 'Fall 2023' }
    end
  end
  