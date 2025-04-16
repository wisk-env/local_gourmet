class FeedbackOption < ApplicationRecord
  has_many :review_feedback_options, dependent: :destroy
  has_many :reviews, through: :review_feedback_options
  
  def self.ransackable_attributes(auth_object = nil)
    ["id", "option_title"]
  end
end
