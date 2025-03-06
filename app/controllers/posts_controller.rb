class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def index
    @posts = Post.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)
    @stamp = current_user.stamps.find_by(post_id: @post.id) if user_signed_in?
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    
    if @post.save
      redirect_to @post, notice: '投稿が作成されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: '投稿が更新されました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: '投稿が削除されました。'
  end
  
  private
  
  def set_post
    @post = Post.find(params[:id])
  end
  
  def post_params
    params.require(:post).permit(:content)
  end
  
  def correct_user
    redirect_to(posts_path, status: :see_other) unless current_user == @post.user
  end
end
