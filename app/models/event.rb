class Event < ApplicationRecord
  belongs_to :organizer, class_name: :Member, foreign_key: :member_id

  has_many :follow_event_followers, class_name: :FollowEvent, foreign_key: :event_id
  has_many :followers , through: :follow_event_followers, source: :member

  has_many :attend_event_attendees, class_name: :AttendEvent, foreign_key: :event_id
  has_many :attendees , through: :attend_event_attendees, source: :member

  has_many :like_event_likers, class_name: :LikeEvent, foreign_key: :event_id
  has_many :likers , through: :like_event_likers, source: :member

  has_many :recommend_event_recommenders, class_name: :RecommendEvent, foreign_key: :event_id
  has_many :recommenders , through: :receommend_event_receommenders, source: :member

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

end

