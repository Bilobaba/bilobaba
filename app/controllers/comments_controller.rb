require 'pry'

class CommentsController < ApplicationController

  # creates a comment that is assigned to an event
  def create
    return unless (comment_params[:content].size > 0)
    @comment = Comment.new
    @comment.content = comment_params[:content]
    @comment.author = current_member
    if (params[:event_id])
      @comment.commentable_id = params[:event_id]
      @comment.commentable_type = Event.name
    elsif (params[:member_id])
      @comment.commentable_id = params[:member_id]
      @comment.commentable_type = Member.name
    elsif (params[:testimonial_id])
      @comment.commentable_id = params[:testimonial_id]
      @comment.commentable_type = Testimonial.name
    else
      puts "comments_controller / create/ commentable_type unknowed"
    end
    ContactMailer.new_user_action('Nouveau commentaire', @comment.commentable.url).deliver_now if @comment.save
    @comment.commentable.interested_members.each do |m|
      ContactMailer.new_comment_event(m,@comment.commentable.url).deliver_now unless  (m == current_member)
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
