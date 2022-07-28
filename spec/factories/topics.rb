FactoryBot.define do
  factory :topic do
    column
    sequence(:name) { |n| "Topic #{n}" }
  end
end
