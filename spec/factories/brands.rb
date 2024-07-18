FactoryBot.define do
  factory :brand do
    name { "Test Brand" }
    country { create(:country) }
    status { "active" }
  end
end
