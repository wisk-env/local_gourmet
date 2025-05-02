# frozen_string_literal: true

class Restaurant < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  validates :lat, presence: true
  validates :lng, presence: true
  validates :lat, uniqueness: { scope: :lng }
  has_many :reviews, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  def self.ransackable_attributes(_auth_object = nil)
    %w[id address]
  end
end
