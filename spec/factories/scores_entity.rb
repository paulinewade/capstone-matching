FactoryBot.define do
    factory :scores_entity do
        student
        project
        pref {1}
    end
end