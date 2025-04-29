FactoryBot.define do
  factory :review_genre do
    sequence(:review_id) { |n| n }
    sequence(:genre_id) { |n| n }
    association :review
    association :genre
  end
end
