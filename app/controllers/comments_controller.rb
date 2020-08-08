class CommentsController < ApplicationController
  layout :false, only: %i[create destroy]
  before_action :authenticate_user!
  before_action :set_comment, only: :destroy
  before_action :set_commentable, only: :create
  after_action :publish_comment, only: :create

  authorize_resource

  def create
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
  end

  def destroy
    @comment.delete
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

  def publish_comment
    return if @commentable.errors.any?

    question_id = @commentable.is_a?(Question) ? @commentable.id : @commentable.question_id

    ActionCable.server.broadcast(
      "questions_#{question_id}_comments",
      @comment
    )
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
