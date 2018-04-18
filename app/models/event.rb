class Event < ApplicationRecord

  include Rails.application.routes.url_helpers
  include AlgoliaSearch

  acts_as_taggable_on :categories

  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :begin_at, presence: true
  validates :end_at, presence: true
  validates :address, presence: true
  validates :note, length: { maximum: 250 }
  validates :price_max, presence: true

  mount_uploader :image, ImageUploader
  mount_uploader :photo1, ImageUploader
  mount_uploader :photo2, ImageUploader
  mount_uploader :photo3, ImageUploader
  mount_uploader :photo4, ImageUploader
  mount_uploader :photo5, ImageUploader
  mount_uploaders :photos, PhotoUploader

  validates :image, file_size: { less_than: 1.megabytes, message: 'L\'image doit faire moins de 1 megabytes' }

  belongs_to :organizer, class_name: :Member, foreign_key: :organizer_id
  belongs_to :teacher, class_name: :Member, foreign_key: :teacher_id, optional: true
  belongs_to :cloudy

  has_many :follow_event_followers, class_name: :FollowEvent, foreign_key: :event_id, dependent: :destroy
  has_many :followers, through: :follow_event_followers, source: :member, dependent: :destroy

  has_many :attend_event_attendees, class_name: :AttendEvent, foreign_key: :event_id, dependent: :destroy
  has_many :attendees, through: :attend_event_attendees, source: :member, dependent: :destroy

  has_many :like_event_likers, class_name: :LikeEvent, foreign_key: :event_id, dependent: :destroy
  has_many :likers, through: :like_event_likers, source: :member, dependent: :destroy

  has_many :recommend_event_recommenders, class_name: :RecommendEvent, foreign_key: :event_id, dependent: :destroy
  has_many :recommenders , through: :recommend_event_recommenders, source: :member, dependent: :destroy

  has_many :comments, as: :commentable
  has_many :authors, through: :comments

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
        price_max.to_s + '€ - Réduit : ' + price_min.to_s + '€'
      else
        price_max.to_s + '€'
      end
    else
      '-'
    end
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

  def self.events
    Event
      .order(begin_at: :asc)
      .where('duration < ?', 4.hours)
      .includes(:attendees)
  end

  def self.workshops
    Event
      .order(begin_at: :asc)
      .where('duration >= ?', 4.hours)
      .includes(:attendees)
  end

  def self.next_events(time = Time.now)
    Event
      .events
      .where('begin_at >= ?', time)
  end

  def self.next_workshops(time = Time.now)
    Event
      .workshops
      .where('begin_at >= ?', time)
  end

  def self.next_week_events(time = Time.now)
    Event
      .events
      .where('begin_at >= ? AND begin_at <= ?', time, time + 1.week)
  end

  def self.events_by_member(member_id)
    Event
    .order(begin_at: :asc)
    .where('duration < ?', 4.hours)
    .where('organizer_id = ? OR teacher_id = ?', member_id, member_id)
  end

  def self.workshops_by_member(member_id)
    Event
    .order(begin_at: :asc)
    .where('duration >= ?', 4.hours)
    .where('organizer_id = ? OR teacher_id = ?', member_id, member_id)
  end

  def soon
    if begin_at.to_date < Date.today
      soon = "Passé"
    elsif self.begin_at.to_date == Date.today
      soon = "Aujourd'hui"
    elsif self.begin_at.to_date == Date.today + 1.day
      soon = "Demain"
    elsif self.begin_at.to_date <= Date.today + 7.day
      soon = "Cette semaine"
    elsif self.begin_at.to_date > Date.today + 7.day
      soon = "Prochainement"
    else
      soon = "Problème"
    end
    return soon
  end

  algoliasearch do

    # list of attribute used to build an Algolia record
    attributes :id, :title, :address, :city, :zip

    # extra_attr will be sent
    add_attribute :organizer_name, :organizer_first_name, :unix_begin_at, :url, :summary,
                  :organizer_avatar, :address, :short_title, :show_begin_at, :organizer_pseudo,
                  :show_price, :organizer_bio, :place_name, :image_url, :categories_names, :category_first,
                  :teacher_pseudo, :teacher_name, :teacher_first_name, :teacher_bio

    # the `searchableAttributes` (formerly known as attributesToIndex) setting defines the attributes
    # you want to search in: here `title`, `subtitle` & `description`.
    # You need to list them by order of importance. `description` is tagged as
    # `unordered` to avoid taking the position of a match into account in that attribute
    searchableAttributes ['title', 'organizer_name', 'organizer_first_name', 'address', 'categories_names',
                          'city', 'zip','summary', 'organizer_avatar','short_title', 'category_first',
                          'show_begin_at', 'organizer_pseudo', 'show_price', 'organizer_bio', 'place_name',
                          'teacher_first_name','teacher_name','teacher_pseudo', 'teacher_bio']

    # the `customRanking` setting defines the ranking criteria use to compare two matching
    # records in case their text-relevance is equal. It should reflect ,your record popularity.
    #customRanking ['desc(likes_count)']
    # customRanking ['asc(unix_begin_at)']

    ranking ['asc(unix_begin_at)']

    # Use the geoloc method to localize
    geoloc :lat, :lng

  end

  def organizer_name
    self.organizer.name
  end

  def organizer_first_name
    self.organizer.first_name
  end

  def organizer_avatar
    return self.organizer.avatar_url
  end

  def organizer_pseudo
    return self.organizer.pseudo
  end

  def organizer_bio
    return self.organizer.bio
  end

  def teacher_name
    self.teacher ? self.teacher.name : ""
  end

  def teacher_first_name
    self.teacher ? self.teacher.first_name : ""
  end

  def teacher_avatar
    self.teacher ? self.teacher.avatar_url : ""
  end

  def teacher_pseudo
    self.teacher ? self.teacher.pseudo : ""
  end

  def teacher_bio
        self.teacher ? self.teacher.bio : ""
  end

  def unix_begin_at
    self.begin_at.to_i
  end

  def url
     return ENV["ROOT_URL"] + event_path(self)
  end

  def image_url
    (self.cloudy && self.cloudy.identifier) ? self.cloudy.prefix_cloudinary + self.cloudy.identifier.to_s : ""
  end

  def summary
    text = I18n.l(self.begin_at, format: '%a %-d %b %Y - %Hh%M') + " " + self.title[0..20].capitalize + "... organisé par " +
    self.organizer.first_name + " " + self.organizer.name + " à " + self.city
    return text
  end

  def short_title
    self.title.length > 32 ? self.title[0..28] + '...' : self.title
  end

  def show_begin_at
    show_begin_at = I18n.l(self.begin_at, format: '%a %-d %b %Y - %Hh%M')
  end

  def show_begin_at_day
    show_begin_at = I18n.l(self.begin_at, format: '%a %-d %b %Y')
  end

  def show_begin_at_hours
    show_begin_at = I18n.l(self.begin_at, format: '%Hh%M')
  end

  def show_begin_at_month_name
    I18n.l(self.begin_at, format: '%B').capitalize
  end


  def show_end_at
    show_end_at = I18n.l(self.end_at, format: '%a %-d %b %Y - %Hh%M')
  end

  def show_end_at_day
    show_end_at = I18n.l(self.end_at, format: '%a %-d %b %Y')
  end

  def show_end_at_hours
    show_end_at = I18n.l(self.end_at, format: '%Hh%M')
  end

  def show_end_at_month_name
    I18n.l(self.end_at, format: '%B').capitalize
  end

  def show_duration
    duration = self.duration
    if duration < 1.day
      show_duration = (duration/1.hour).to_i.to_s + 'h' + (duration%1.hour/1.minute).to_i.to_s.rjust(2, '0')
    else
      show_duration = ((duration/1.day).to_i + 1).to_s + ' jours'
    end
  end

  def show_begin_end
    show_begin_end = I18n.l(self.begin_at, format: '%Hh%M') + '-' + I18n.l(self.end_at, format: '%Hh%M')
  end

  def show_date_begin_end
    show_date_begin_end = I18n.l(self.begin_at, format: '%a %-d %b %Y') + '-' + I18n.l(self.end_at, format: '%a %-d %b %Y')
  end

  def categories_names
    self.categories.join(', ')
  end

  def category_first
    self.categories.first ? self.categories.first.name : ""
  end


  def interested_members
    interested_members = []
    interested_members << self.organizer
    interested_members << self.teacher
    interested_members += self.authors
    interested_members.uniq!
    return interested_members
  end
end
