class ReviewsController < ApplicationController
  before_action :search_params, only: %i[index search]

  def index
    @reviews = Review.all
    @genres = Genre.all
    @feedback_options = FeedbackOption.all
  end

  def show
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.find(params[:id])
  end

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new(review_params)
    if @review.save
      flash[:notice] = '口コミを投稿しました'
      redirect_to restaurant_path(@review.restaurant_id)
    else
      flash.now[:alert] = '口コミ投稿に失敗しました'
      render 'new'
    end
  end

  def search
    @reviews = Review.all
    @genres = Genre.all
    @feedback_options = FeedbackOption.all
    @results = @q.result.distinct
  end

  private

  def review_params
    params.require(:review).permit(:menu, :price, :visit_date, :visit_time, :number_of_visitors, :comment, :image, :user_id, :restaurant_id, feedback_option_ids: [], genre_ids: [])
  end

  def search_params
    @q = Review.ransack(params[:q])
  end
end
