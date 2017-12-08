class Event < ApplicationRecord

  mount_uploader :image, ImageUploader
  mount_uploader :photo1, ImageUploader
  mount_uploader :photo2, ImageUploader
  mount_uploader :photo3, ImageUploader
  mount_uploader :photo4, ImageUploader
  mount_uploaders :photos, PhotoUploader


  belongs_to :organizer, class_name: :Member, foreign_key: :member_id

  has_many :follow_event_followers, class_name: :FollowEvent, foreign_key: :event_id
  has_many :followers , through: :follow_event_followers, source: :member

  has_many :attend_event_attendees, class_name: :AttendEvent, foreign_key: :event_id
  has_many :attendees , through: :attend_event_attendees, source: :member

  has_many :like_event_likers, class_name: :LikeEvent, foreign_key: :event_id
  has_many :likers , through: :like_event_likers, source: :member

  has_many :recommend_event_recommenders, class_name: :RecommendEvent, foreign_key: :event_id
  has_many :recommenders , through: :recommend_event_recommenders, source: :member

  has_many :comments, class_name: 'Comment', foreign_key: 'event_id'

  def participate(current_member, status)
    if status == 'in'
      attendees << current_member unless attendees.include? current_member
    elsif status == 'out'
      attendees.delete(current_member)
    end
  end

  def participate?(current_member)
    attendees.include? current_member
  end


  def like(current_member, status)
    if status == 'in'
      likers << current_member unless likers.include? current_member
    elsif status == 'out'
      likers.delete(current_member)
    end
  end

  def like?(current_member)
    likers.include? current_member
  end


  def recommend(current_member, status)
    if status == 'in'
      recommenders << current_member unless recommenders.include? current_member
    elsif status == 'out'
      recommenders.delete(current_member)
    end
  end

  def recommend?(current_member)
    recommenders.include? current_member
  end


  def follow(current_member, status)
    if status == 'in'
      followers << current_member unless followers.include? current_member
    elsif status == 'out'
      followers.delete(current_member)
    end
  end

  def follow?(current_member)
    followers.include? current_member
  end

end
