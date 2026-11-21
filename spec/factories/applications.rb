FactoryBot.define do
  factory :application do
    association :recruitment
    association :user
    status { "pending" }
  end
end
