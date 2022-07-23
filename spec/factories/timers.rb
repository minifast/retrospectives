FactoryBot.define do
  factory :timer do
    board
    sequence(:duration) { |n| n.minutes }
  end
end
