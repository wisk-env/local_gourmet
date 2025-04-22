FactoryBot.define do
  factory :restaurant do
    name { Faker::Restaurant.name }  
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }
    address { Faker::Address.full_address }
  end
end
