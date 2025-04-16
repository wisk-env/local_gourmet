class Genre < ApplicationRecord
  has_many :review_genres
  has_many :reviews, through: :review_genres

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name"]
  end
end
