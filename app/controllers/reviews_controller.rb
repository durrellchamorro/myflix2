class ReviewsController < ApplicationController
  before_action :require_user

  def create
    review = Review.create(review_data)
    if review.persisted?
      flash[:success] = "Review created successfully."
    else
      flash[:danger] = "That didn't work."
    end

    @video = Video.find(review_params[:video_id])
    @reviews = Review.where(video: review_params[:video_id])

    render "videos/show"
  end

  private

  def review_params
    params.permit(:video_id, :content, :rating)
  end

  def review_data
    review_data = review_params
    review_data["user_id"] = current_user.id
    review_data
  end
end
