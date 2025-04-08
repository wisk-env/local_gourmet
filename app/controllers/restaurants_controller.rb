class RestaurantsController < ApplicationController
  def index
    @restaurant = Restaurant.new
    @restaurants = Restaurant.all
  end

  def new
    @not_registered_data = not_registered_params
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      redirect_to restaurant_path(@restaurant)
    else
      flash[:alert] = 'お店の登録に失敗しました'
      render 'new'
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :lat, :lng, :address)
  end

  def not_registered_params
    params.permit(:lat, :lng, :address)
  end
end
