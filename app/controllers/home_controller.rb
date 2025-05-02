# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @restaurants = Restaurant.joins(:bookmarks)
                    .select('count(bookmarks.restaurant_id) as bookmarks_count', 'restaurants.*')
                    .group(:id).order(bookmarks_count: :desc).limit(3)
  end
end
