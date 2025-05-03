# frozen_string_literal: true

class RestaurantRegisteredStatusesController < ApplicationController
  before_action :authenticate_user!
  before_action :params_required, only: %i[new]

  def index
    @restaurants = Restaurant.all
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def new
    @restaurant = Restaurant.find_or_initialize_by(check_params)
    if @restaurant&.name
      redirect_to restaurant_registered_status_path(@restaurant)
    else
      redirect_to new_restaurant_path(check_params)
    end
  end

  private

  def check_params
    params.permit(:lat, :lng, :address)
  end

  def params_required
    return unless params[:lat].blank? || params[:lng].blank? || params[:address].blank?

    redirect_to restaurant_registered_statuses_path
  end
end
