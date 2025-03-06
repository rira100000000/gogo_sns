class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [:destroy]
  before_action :correct_user, only: [:destroy]
  
  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    
    if @comment.save
      redirect_to @post, notice: 'コメントが投稿されました。'
    else
      redirect_to @post, alert: 'コメントの投稿に失敗しました。'
    end
  end

  def destroy
    @comment.destroy
    redirect_to @post, notice: 'コメントが削除されました。'
  end
  
  private
  
  def set_post
    @post = Post.find(params[:post_id])
  end
  
  def set_comment
    @comment = @post.comments.find(params[:id])
  end
  
  def comment_params
    params.require(:comment).permit(:content)
  end
  
  def correct_user
    redirect_to(@post, status: :see_other) unless current_user == @comment.user
  end
end
