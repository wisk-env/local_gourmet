FactoryBot.define do
  factory :review do
    menu { Faker::Food.dish }
    price { 1000 }
    visit_date { '土日' }
    visit_time { 'ランチ' }
    number_of_visitors { 2 }
    comment { Faker::Restaurant.review }
    sequence(:user_id) { |n| n }
    sequence(:restaurant_id) { |n| n }
    association :user
    association :restaurant
  end
end
