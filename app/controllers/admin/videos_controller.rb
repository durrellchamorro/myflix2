class Admin::VideosController < ApplicationController
  before_action :require_user, :require_admin

  def new
    @video = Video.new
  end

  def create
    video = Video.new(video_params)

    create_video(video)

    if video.persisted?
      @flash_message = "#{video.title} was successfully created."
      @video = Video.new
      render :new_with_success_flash
    else
      @flash_message = "That didn't work. No input can be blank and a picutre must be chosen."
      @video = video
      render :new_with_danger_flash
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :category_id, :token)
  end

  def photo_params
    params.require(:photo).permit(:image)
  end

  def create_photo(video)
    if params[:photo]
      photo = Photo.create(photo_params)
      photo.video = video
      photo.save
    else
      false
    end
  end

  def create_video(video)
    Video.transaction do
      fail ActiveRecord::Rollback unless video.save
      fail ActiveRecord::Rollback unless create_photo(video)
    end
  end
end
