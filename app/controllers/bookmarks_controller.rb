# frozen_string_literal: true

class BookmarksController < ApplicationController
  def create
    restaurant = Restaurant.find(params[:restaurant_id])
    current_user.bookmark(restaurant)
    flash[:success] = 'ブックマークしました'
    redirect_back fallback_location: restaurants_path
  end

  def destroy
    restaurant = current_user.bookmarks.find(params[:id]).restaurant
    current_user.unbookmark(restaurant)
    flash[:success] = 'ブックマークを解除しました'
    redirect_back fallback_location: restaurants_path
  end
end
