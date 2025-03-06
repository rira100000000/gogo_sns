class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:timeline]
  
  def index
    @posts = Post.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
  end

  def timeline
    @posts = current_user.feed.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
  end
end
