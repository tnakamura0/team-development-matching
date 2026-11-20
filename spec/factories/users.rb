FactoryBot.define do
  factory :user do
    name { "user" }
    period { 50 }
    required_status { "basic_step_completed" }
    sequence(:email_address) { |n| "user#{n}@example.com" }
    password { "password" }
  end
end
