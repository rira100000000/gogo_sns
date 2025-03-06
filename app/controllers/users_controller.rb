class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_user, except: [:index]
  before_action :correct_user, only: [:edit, :update]
  
  def index
    @users = User.all.page(params[:page]).per(20)
  end
  
  def show
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(10)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'プロフィールが更新されました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def following
    @title = "フォロー中"
    @users = @user.following.page(params[:page]).per(20)
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @users = @user.followers.page(params[:page]).per(20)
    render 'show_follow'
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:username, :profile)
  end
  
  def correct_user
    redirect_to(root_path, status: :see_other) unless current_user == @user
  end
end
