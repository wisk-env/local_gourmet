FactoryBot.define do
  factory :like do
    user_id { |n| n }
    review_id { |n| n }
    association :user
    association :review
  end
end
