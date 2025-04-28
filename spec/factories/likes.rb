FactoryBot.define do
  factory :like do
    sequence(:user_id) { |n| n }
    sequence(:review_id) { |n| n }
    association :user
    association :review
  end
end
