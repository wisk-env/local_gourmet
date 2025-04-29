class Genre < ApplicationRecord
  validates :name, presence: true
  has_many :review_genres, dependent: :destroy
  has_many :reviews, through: :review_genres

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name"]
  end
end
