class RestaurantUnregisteredStatusesController < ApplicationController
  def index
    @restaurant_params = unregistered_params
  end

  private

  def unregistered_params
    params.permit(:lat, :lng, :address)
  end
end
