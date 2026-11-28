FactoryBot.define do
  factory :notification do
    association :application
    recipient { application.recruitment.user }
    action { "applied" }

    trait :approved do
      recipient { application.user }
      action { "approved" }
    end

    trait :rejected do
      recipient { application.user }
      action { "rejected" }
    end
  end
end
