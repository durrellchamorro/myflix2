class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    queue_video unless video_already_in_queue?
    redirect_to my_queue_path
  end

  def destroy

  end

  private

  def queue_video
    QueueItem.create(video_id: params["video_id"], user: current_user,
                     position: new_queue_item_position)
  end

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def video_already_in_queue?
    QueueItem.where(user: current_user, video_id: params["video_id"]).present?
  end
end
