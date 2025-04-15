class ProfilesController < ApplicationController
  def show
    @user = current_user
    @bookmark_restaurants = current_user.bookmark_restaurants
    @reviews = current_user.reviews
  end
end
