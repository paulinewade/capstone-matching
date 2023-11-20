FactoryBot.define do
    factory :student do
      user
      course
      uin { '123456789' }
      gender { 'Male' }
      nationality { 'American' }
      work_auth { 'Citizen' }
      contract_sign { 'all' }
      
      trait :male do
        gender { 'Male' }
      end
  
      trait :female do
        gender { 'Female' }
      end
    end
    
  end
  