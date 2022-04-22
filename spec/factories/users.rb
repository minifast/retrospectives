require 'factory_bot'

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "#{Faker::Name.first_name}#{n}@example.com" }
    password { 'password' }
  end
end
