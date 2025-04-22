class RestaurantRegisteredStatusesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @restaurants = Restaurant.all
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def new
    @restaurant = Restaurant.find_or_initialize_by(check_params)
    if @restaurant && @restaurant.name
      redirect_to restaurant_registered_status_path(@restaurant)
    else
      redirect_to restaurant_unregistered_statuses_path(check_params)
    end
  end

  private

  def check_params
    params.permit(:lat, :lng, :address)
  end
end
