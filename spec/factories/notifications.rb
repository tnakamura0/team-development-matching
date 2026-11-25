FactoryBot.define do
  factory :notification do
    association :application
    recipient { application.recruitment.user }
    actor { application.user }
    action { "applied" }
  end
end
