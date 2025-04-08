class Restaurant < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  validates :lat, presence: true
  validates :lng, presence: true
  validates :lat, uniqueness: { scope: :lng }
end
