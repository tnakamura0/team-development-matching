FactoryBot.define do
  factory :recruitment do
    association :user
    title { "チーム開発をやってみたい！！！" }
    body { "チーム開発を行うメンバーを募集します！実務未経験大歓迎！" }
    closing_date { Date.current + 1.days }
    positions_count { 1 }
    required_status { "graduated" }
    accepting_applications { true }
  end
end
