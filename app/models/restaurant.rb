class Restaurant < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  validates :lat, presence: true
  validates :lng, presence: true
  validates :lat, uniqueness: { scope: :lng }
  has_many :reviews

  def self.ransackable_attributes(auth_object = nil)
    ["id", "address"]
  end
end
