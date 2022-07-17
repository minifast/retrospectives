require 'factory_bot'

FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    image_url { "https://placekitten.com/80/80" }
    sequence(:email) { |n| "#{name}#{n}@example.com" }
  end
end
