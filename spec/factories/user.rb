# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Internet.username }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
