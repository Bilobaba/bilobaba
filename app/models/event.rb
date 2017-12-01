class Event < ApplicationRecord
  belongs_to :organizer, class_name: :Member, foreign_key: :member_id

  has_many :follow_event_followers, class_name: :FollowEvent, foreign_key: :event_id
  has_many :followers , through: :follow_event_followers, source: :member

  has_many :attend_event_attendees, class_name: :AttendEvent, foreign_key: :event_id
  has_many :attendees , through: :attend_event_attendees, source: :member
end

