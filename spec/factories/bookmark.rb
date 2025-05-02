# frozen_string_literal: true

FactoryBot.define do
  factory :bookmark do
    sequence(:user_id) { |n| n }
    sequence(:restaurant_id) { |n| n }
    association :user
    association :restaurant
  end
end
