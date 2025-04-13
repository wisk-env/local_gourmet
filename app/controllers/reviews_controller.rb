class ReviewsController < ApplicationController
  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    if @review.save
      flash[:notice] = '口コミを投稿しました'
      redirect_to restaurant_path(@review.restaurant_id)
    else
      flash[:alert] = '口コミ投稿に失敗しました'
      render 'new'
    end
  end

  private

  def review_params
    params.require(:review).permit(:menu, :price, :visit_date, :visit_time, :number_of_visitors, :comment, :user_id, :restaurant_id, feedback_option_ids: [], genre_ids: [])
  end
end
