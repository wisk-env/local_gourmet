class ReviewFeedbackOption < ApplicationRecord
  belongs_to :review
  belongs_to :feedback_option
end
