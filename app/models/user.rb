class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  before_create :default_icon
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true
  attr_accessor :current_password
  has_one_attached :avatar
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_restaurants, through: :bookmarks, source: :restaurant
  has_many :reviews

  def default_icon
    if !self.avatar.attached?
      self.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default_icon.png')), filename: 'default_icon.png', content_type: 'image/png')
    end
  end

  def bookmark(restaurant)
    bookmark_restaurants << restaurant
  end

  def unbookmark(restaurant)
    bookmark_restaurants.destroy(restaurant)
  end

  def bookmark?(restaurant)
    bookmark_restaurants.include?(restaurant)
  end
end
