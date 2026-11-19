FactoryBot.define do
  factory :user do
    name { "user" }
    period { 50 }
    sequence(:email_address) { |n| "user#{n}@example.com" }
    password { "password" }
  end
end
