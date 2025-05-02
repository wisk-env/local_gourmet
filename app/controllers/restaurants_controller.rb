# frozen_string_literal: true

class RestaurantsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  before_action :params_required, only: %i[new]
  before_action :already_registered, only: %i[new]

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
    if @restaurant.name.blank?
      flash[:alert] = 'お店の登録に失敗しました。飲食店名を入力して下さい。'
      redirect_to new_restaurant_path(restaurant_params)
    elsif @restaurant.save!
      flash[:notice] = 'お店を登録しました。さっそくお店の口コミを投稿してみましょう。'
      redirect_to restaurant_path(@restaurant)
    else
      flash[:alert] = 'お店の登録に失敗しました'
      redirect_to new_restaurant_path(restaurant_params)
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @reviews = @restaurant.reviews
                .includes(:genres,
                          :feedback_options,
                          :likes,
                          { user: { avatar_attachment: :blob } },
                          { image_attachment: :blob })
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :lat, :lng, :address)
  end

  def not_registered_params
    params.permit(:lat, :lng, :address)
  end

  def params_required
    redirect_to restaurant_registered_statuses_path if params[:lat].blank? || params[:lng].blank? || params[:address].blank?
  end

  def already_registered
    if Restaurant.find_by(lat: params[:lat]).present? || Restaurant.find_by(lng: params[:lng]).present?
      restaurant = Restaurant.find_by(lat: params[:lat], lng: params[:lng])
      redirect_to restaurant_path(restaurant)
    end
  end
end
