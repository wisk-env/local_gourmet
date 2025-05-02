# frozen_string_literal: true

class FeedbackOption < ApplicationRecord
  validates :option_title, presence: true
  has_many :review_feedback_options, dependent: :destroy
  has_many :reviews, through: :review_feedback_options

  def self.ransackable_attributes(_auth_object = nil)
    %w[id option_title]
  end
end
