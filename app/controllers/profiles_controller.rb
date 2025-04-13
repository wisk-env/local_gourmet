class ProfilesController < ApplicationController
  def show
    @user = current_user
    @bookmark_restaurants = current_user.bookmark_restaurants
  end
end
