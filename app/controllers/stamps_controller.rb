class StampsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  
  def create
    @stamp = current_user.stamps.build(post: @post)
    
    if @stamp.save
      redirect_to @post, notice: 'スタンプを付けました。'
    else
      redirect_to @post, alert: 'スタンプを付けられませんでした。'
    end
  end

  def destroy
    @stamp = current_user.stamps.find_by(post_id: @post.id)
    
    if @stamp && @stamp.destroy
      redirect_to @post, notice: 'スタンプを外しました。'
    else
      redirect_to @post, alert: 'スタンプを外せませんでした。'
    end
  end
  
  private
  
  def set_post
    @post = Post.find(params[:post_id])
  end
end
