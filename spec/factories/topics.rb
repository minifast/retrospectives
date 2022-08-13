FactoryBot.define do
  factory :topic do
    user
    column
    sequence(:name) { |n| "Topic #{n}" }
  end
end
