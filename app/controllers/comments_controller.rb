class CommentsController < ApplicationController
  layout :false, only: %i[create]
  before_action :authenticate_user!
  before_action :set_commentable

  def create
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    @commentable = commentable_name.classify.constantize.find(params[:id])
  end

  def commentable_name
    params[:commentable]
  end
end
