# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @bookmark_restaurants = current_user.bookmark_restaurants
    @reviews = current_user.reviews
                .includes(:genres,
                          :feedback_options,
                          :likes,
                          { image_attachment: :blob })
  end
end
