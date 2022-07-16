FactoryBot.define do
  factory :column do
    name { |n| "#{Faker::Name}#{n}" }
    board
  end
end
