FactoryBot.define do
  factory :notification do
    association :application
    recipient { application.recruitment.user }
    action { "applied" }
  end
end
