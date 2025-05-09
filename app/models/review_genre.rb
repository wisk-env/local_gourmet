# frozen_string_literal: true

class ReviewGenre < ApplicationRecord
  belongs_to :review
  belongs_to :genre
  validates :review_id, uniqueness: { scope: :genre_id }
end
