class RelationshipsController < ApplicationController
  before_action :require_user

  def index
    @relationships = current_user.following_relationships.page(params[:page]).per(20)
  end

  def destroy
    relationship = Relationship.find_by(follower: current_user, id: params[:id])

    if relationship
      relationship.destroy
      flash[:success] = "You successfully unfollowed that person."
    else
      flash[:danger] = "That didn't work"
    end

    redirect_to people_path
  end

  def create
    Relationship.create(leader_id: params[:leader_id], follower: current_user) if current_user.can_follow?(params[:leader_id])

    redirect_to people_path
  end
end
