FactoryBot.define do
  factory :genre do
    sequence(:name) { |n| "genre_tag#{n}" } 
  end
end
