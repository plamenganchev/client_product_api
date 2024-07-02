FactoryBot.define do
  factory :card do
    product { nil }
    user { nil }
    activation_number { "MyString" }
    pin { "MyString" }
    status { "MyString" }
  end
end
