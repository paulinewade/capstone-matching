FactoryBot.define do
    factory :scores_value do
      scores_entity
      scores_attribute
      feature_score { 10.0 }
    end
  end
  