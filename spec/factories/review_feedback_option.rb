# frozen_string_literal: true

FactoryBot.define do
  factory :review_feedback_option do
    sequence(:review_id) { |n| n }
    sequence(:feedback_option_id) { |n| n }
    association :review
    association :feedback_option
  end
end
