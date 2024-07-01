FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { '123456' }


    trait :admin do
      association :user_role, factory: [:user_role, :admin]
      email { 'admin@example.com' }
    end

    trait :client do
      association :user_role, factory: [:user_role, :client]

      email { 'client@example.com' }
    end
  end
end
