class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  before_create :default_icon
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true
  validates :password_confirmation, presence: true
  attr_accessor :current_password
  has_one_attached :avatar
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_restaurants, through: :bookmarks, source: :restaurant
  has_many :reviews, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_reviews, through: :likes, source: :review

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

  def own?(object)
    object.user_id == id
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.name = 'ゲスト'
      user.password = SecureRandom.urlsafe_base64
    end
  end
end
