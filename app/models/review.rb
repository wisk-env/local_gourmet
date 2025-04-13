class Review < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  has_many :review_feedback_options
  has_many :feedback_options, through: :review_feedback_options
  has_many :review_genres
  has_many :genres, through: :review_genres
end
