class VideosController < ApplicationController
  before_action :require_user

  def index
    @categories = Category.joins(:videos).distinct.order(:name)
  end

  def show
    @video = Video.friendly.find(params[:id])
    @reviews = Review.valid_reviews(@video)
  end

  def search
    @videos = Video.search_by_title(params[:search_term])
  end
end
