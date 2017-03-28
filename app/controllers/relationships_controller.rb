class RelationshipsController < ApplicationController
  before_action :require_user

  def index
    @relationships = current_user.following_relationships
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
end
