# frozen_string_literal: true

class LikesController < ApplicationController
  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.find(params[:review_id])
    @like = current_user.likes.new(review_id: @review.id)
    @like.save
  end

  def destroy
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = current_user.like_reviews.find(params[:review_id])
    @like = current_user.likes.find_by(review_id: @review.id)
    @like.destroy
  end
end
