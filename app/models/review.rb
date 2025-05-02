# frozen_string_literal: true

class Review < ApplicationRecord
  validates :menu, presence: true
  validates :price, presence: true
  validates :visit_date, presence: true
  validates :visit_time, presence: true
  validates :number_of_visitors, presence: true
  has_one_attached :image
  belongs_to :user
  belongs_to :restaurant
  has_many :review_feedback_options, dependent: :destroy
  has_many :feedback_options, through: :review_feedback_options
  has_many :review_genres, dependent: :destroy
  has_many :genres, through: :review_genres
  has_many :likes, dependent: :destroy
  has_many :users, through: :likes

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  def self.ransackable_attributes(auth_object = nil)
    ['menu', 'price', 'visit_date', 'visit_time', 'comment', 'feedback_options', 'genres']
  end

  def self.ransackable_associations(auth_object = nil)
    auth_object ? super : %w(feedback_options genres restaurant)
  end
end
