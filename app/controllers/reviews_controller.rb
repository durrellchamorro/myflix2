class ReviewsController < ApplicationController
  before_action :require_user

  def create
    review = Review.create(review_data)
    if review.persisted?
      flash[:success] = "Review created successfully."
    else
      flash[:danger] = "You must fill in all fields. If you did, then you already rated this video or it is in your queue. Queued videos can only be rated in the queue. You can update your rating by putting the video in the queue and changing the rating there."
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