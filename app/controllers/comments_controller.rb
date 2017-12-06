class CommentsController < ApplicationController

  # creates a comment that is assigned to an event
  def create
    @comment = Comment.new
    @comment.content = comment_params[:content]
    @comment.autor = current_member
    @comment.event_id = params[:event_id]
    @comment.save
  end

  # deletes a comment
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
