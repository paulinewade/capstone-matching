FactoryBot.define do
    factory :professor_preference do
      project
      professor
      pref {1}
    end
  end