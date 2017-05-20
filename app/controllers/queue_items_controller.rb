class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items.page(params[:page]).per(20)
  end

  def create
    queue_video unless video_already_in_queue?
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params["id"])

    if queue_item && queue_item.user == current_user
      QueueItem.delete(queue_item)
      current_user.normalize_queue_item_positions
    end

    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_items
      current_user.normalize_queue_item_positions
    rescue NoMethodError
      flash[:danger] = "You must have items in your queue to update it."
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "Invalid position numbers."
    end

    redirect_to my_queue_path
  end

  private

  def queue_video
    QueueItem.create(video: video, user: current_user,
                     position: new_queue_item_position)
  end

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def video_already_in_queue?
    QueueItem.where(user: current_user, video: video).present?
  end

  def video
    @video ||= Video.friendly.find(params[:video_slug])
  end

  def update_queue_items
    ActiveRecord::Base.transaction do
      params["queue_items"].each do |data|
        queue_item = QueueItem.find(data[:id])
        queue_item.update!(position: data[:position], rating: data["rating"]) if queue_item.try(:user) == current_user
      end
    end
  end
end
