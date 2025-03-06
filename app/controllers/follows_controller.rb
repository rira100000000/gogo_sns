class FollowsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    redirect_to @user, notice: "#{@user.username}さんをフォローしました。"
  end

  def destroy
    @follow = Follow.find(params[:id])
    @user = @follow.followed
    current_user.unfollow(@user)
    redirect_to @user, notice: "#{@user.username}さんのフォローを解除しました。"
  end
end
