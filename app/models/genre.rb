class Genre < ApplicationRecord
  has_many :review_genres
  has_many :reviews, through: :review_genres
end
