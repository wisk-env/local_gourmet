class FeedbackOption < ApplicationRecord
  has_many :review_feedback_options, dependent: :destroy
  has_many :reviews, through: :review_feedback_options
end
