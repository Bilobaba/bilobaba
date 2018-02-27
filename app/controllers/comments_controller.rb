class CommentsController < ApplicationController

  # creates a comment that is assigned to an event
  def create
    @comment = Comment.new
    @comment.content = comment_params[:content]
    @comment.author = current_member
    @comment.event_id = params[:event_id]
    ContactMailer.new_user_action('Nouveau commentaire', 'http://www.bilobaba.com/events/' + @comment.event_id.to_s).deliver_now if @comment.save
    @comment.event.interested_members.each do |m|
      ContactMailer.new_comment_event(m,@comment.event.url).deliver_now unless  (m == current_member)
    end
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
