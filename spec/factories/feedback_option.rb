# frozen_string_literal: true

FactoryBot.define do
  factory :feedback_option do
    sequence(:option_title) { |n| "feedback_tag#{n}" }
  end
end
