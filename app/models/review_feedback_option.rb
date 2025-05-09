# frozen_string_literal: true

class ReviewFeedbackOption < ApplicationRecord
  belongs_to :review
  belongs_to :feedback_option
  validates :review_id, uniqueness: { scope: :feedback_option_id }
end
