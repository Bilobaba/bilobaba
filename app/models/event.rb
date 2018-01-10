class Event < ApplicationRecord

  include Rails.application.routes.url_helpers
  include AlgoliaSearch


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
      if (price_min && price_min != price_max) && (price_min > 0)
        price_min.to_s + '€ - ' + price_max.to_s + '€'
      else
        price_max.to_s + '€'
      end
    else
      '-'
    end
  end

  def participate(current_member)
    if participate? current_member
      attendees.delete(current_member)
    else
      attendees << current_member
    end
  end

  def participate?(current_member)
    attendees.include? current_member
  end

  def like(current_member)
    if like? current_member
      likers.delete(current_member)
    else
      likers << current_member
    end
  end

  def like?(current_member)
    likers.include? current_member
  end

  def recommend(current_member)
    if recommend? current_member
      recommenders.delete(current_member)
    else
      recommenders << current_member
    end
  end

  def recommend?(current_member)
    recommenders.include? current_member
  end

  def follow(current_member)
    if follow? current_member
      followers.delete(current_member)
    else
      followers << current_member
    end
  end

  def follow?(current_member)
    followers.include? current_member
  end

  def return_pictures
    pictures = []
    pictures << { url: photo1.url, filename: photo1.file.filename } if photo1.url.present?
    pictures << { url: photo2.url, filename: photo2.file.filename } if photo2.url.present?
    pictures << { url: photo3.url, filename: photo3.file.filename } if photo3.url.present?
    pictures << { url: photo4.url, filename: photo4.file.filename } if photo4.url.present?
    pictures << { url: photo5.url, filename: photo5.file.filename } if photo5.url.present?
    return pictures
  end

  def self.next_events(time = Time.now)
    Event
      .order(begin: :asc)
      .where('begin >= ?', time)
      .includes(:attendees)
  end

  algoliasearch do

    # list of attribute used to build an Algolia record
    attributes :id, :title, :description, :adress, :town, :zip

    # extra_attr will be sent
    add_attribute :member_name, :member_first_name, :event_begin, :event_url, :event_summary,
                  :member_avatar

    # the `searchableAttributes` (formerly known as attributesToIndex) setting defines the attributes
    # you want to search in: here `title`, `subtitle` & `description`.
    # You need to list them by order of importance. `description` is tagged as
    # `unordered` to avoid taking the position of a match into account in that attribute.
    searchableAttributes ['event_begin','title', 'member_name', 'member_first_name', 'adress', 'town', 'zip',
      'event_summary', 'description', 'member_avatar']

    # the `customRanking` setting defines the ranking criteria use to compare two matching
    # records in case their text-relevance is equal. It should reflect your record popularity.
    #customRanking ['desc(likes_count)']
    customRanking ['asc(event_begin)']

    # Use the geoloc method to localize
    geoloc :lat, :lng

  end

  def member_name
    self.organizer.name
  end

  def member_first_name
    self.organizer.first_name
  end

  def event_begin
    self.begin.to_i
  end

  def event_url
    if Rails.env == "development"
      return 'localhost:3000' + event_path(self)
    else
      return 'www.bilobaba.com' + event_path(self)
    end
  end

  def event_summary
    text = I18n.l(self.begin, format: '%a %-d %b %Y - %Hh%M') + " " + self.title[0..20].capitalize + "... organisé par " +
    self.organizer.first_name + " " + self.organizer.name + " à " + self.town
    return text
  end

  def member_avatar
    return self.organizer.avatar.url
  end

end
