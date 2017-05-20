class VideosController < ApplicationController
  before_action :require_user

  def index
    @categories = Category.joins(:videos).distinct.order(:name).page(params[:page]).per(10)
  end

  def show
    @video = Video.friendly.find(params[:id]).decorate
    @reviews = Review.valid_reviews(@video)
  end

  def search
    query = params.fetch(:search_term).presence || "*"
    @videos = Video.search(query, fields: [{ title: :word_start }, :description])
  end

  def show_advanced_search
    @videos = []
    render :advanced_search
  end

  def advanced_search
    Video.set_advanced_search_options(params[:rating_from], params[:rating_to], params[:reviews])

    query = params.fetch(:query).presence || "*"
    @videos = VideoDecorator.decorate_collection(Video.advanced_search(query))
  end

  def autocomplete
    render json: Video.search(params[:term],
                              fields: [:title], match: :word_start, limit: 10,
                              load: false,
                              misspellings: { below: 5 }).map(&:title)
  end
end
