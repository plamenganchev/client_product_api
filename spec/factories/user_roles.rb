FactoryBot.define do
  factory :user_role do
    trait :admin do
      role {'admin'}
    end

    trait :client do
      role {'client'}
    end
  end
end
