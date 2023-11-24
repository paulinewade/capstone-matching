FactoryBot.define do
    factory :professor do
      admin {false}
      verified {true}
      user
    end
  end