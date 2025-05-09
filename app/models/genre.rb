# frozen_string_literal: true

class Genre < ApplicationRecord
  validates :name, presence: true
  has_many :review_genres, dependent: :destroy
  has_many :reviews, through: :review_genres

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name]
  end
end
