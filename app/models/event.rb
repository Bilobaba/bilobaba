class Event < ApplicationRecord



  validates :title, presence: true, length: { minimum: 5 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :begin, presence: true
  validates :end, presence: true
  validates :adress, presence: true
  validates :town, presence: true
  validates :zip, presence: true, length: { is: 5 }


  mount_uploader :image, ImageUploader
  mount_uploader :photo1, ImageUploader
  mount_uploader :photo2, ImageUploader
  mount_uploader :photo3, ImageUploader
  mount_uploader :photo4, ImageUploader
  mount_uploader :photo5, ImageUploader
  mount_uploaders :photos, PhotoUploader

  belongs_to :organizer, class_name: :Member, foreign_key: :member_id

  has_many :follow_event_followers, class_name: :FollowEvent, foreign_key: :event_id, dependent: :destroy
  has_many :followers, through: :follow_event_followers, source: :member, dependent: :destroy

  has_many :attend_event_attendees, class_name: :AttendEvent, foreign_key: :event_id, dependent: :destroy
  has_many :attendees, through: :attend_event_attendees, source: :member, dependent: :destroy

  has_many :like_event_likers, class_name: :LikeEvent, foreign_key: :event_id, dependent: :destroy
  has_many :likers, through: :like_event_likers, source: :member, dependent: :destroy

  has_many :recommend_event_recommenders, class_name: :RecommendEvent, foreign_key: :event_id, dependent: :destroy
  has_many :recommenders , through: :recommend_event_recommenders, source: :member, dependent: :destroy

  has_many :comments, class_name: 'Comment', foreign_key: 'event_id', dependent: :destroy

  def participate(current_member)
    if attendees.include? current_member
      attendees.delete(current_member)
    else
      attendees << current_member
    end
  end

  def participate?(current_member)
    attendees.include? current_member
  end

  def show_availability
    if members_max > 0
      if attendees.size == members_max
        'complet'
      else
        attendees.size.to_s + ' / ' + members_max.to_s
      end
    else
      attendees.size.to_s
    end
  end

  def show_price
    if price_max && price_max > 0
      if price_min && price_min != price_max
        price_min.to_s + '€ - ' + price_max.to_s + '€'
      else
        price_max.to_s + '€'
      end
    else
      '-'
    end
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

  def self.next_events
    Event
      .order(begin: :asc)
      .where('begin >= ?', Time.now)
      .includes(:attendees)
  end

end
