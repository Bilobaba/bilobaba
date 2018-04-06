class Member < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook]

  mount_uploader :avatar, AvatarUploader

  # validates :avatar, presence: true
  validates :pseudo, presence: true
  validates :pseudo, uniqueness: true
  validates :first_name, presence: true
  validates :name, presence: true
  validates :bio, presence: true
  validates :gender, presence: true
  # validates :birth_date, presence: true
  # validates :address, presence: true
  # validates :zip, presence: true
  # validates :city, presence: true
  # validates :country, presence: true

  has_many :organize_events, class_name: :Event, foreign_key: :organizer_id
  has_many :teach_events, class_name: :Event, foreign_key: :teacher_id

  # follower_follows "names" the Follow join table for accessing through the follower association
  has_many :follower_follows, foreign_key: :followee_id, class_name: "Follow"
  # source: :follower matches with the belong_to :follower identification in the Follow model
  has_many :followers, through: :follower_follows, source: :follower

  # followee_follows "names" the Follow join table for accessing through the followee association
  has_many :followee_follows, foreign_key: :follower_id, class_name: "Follow"
  # source: :followee matches with the belong_to :followee identification in the Follow model
  has_many :followees, through: :followee_follows, source: :followee

  has_many :follow_event_followees, class_name: :FollowEvent, foreign_key: :member_id
  has_many :follow_events , through: :follow_event_followees, source: :event

  has_many :attend_event_attends, class_name: :AttendEvent, foreign_key: :member_id
  has_many :attend_events , through: :attend_event_attends, source: :event

  has_many :like_event_likes, class_name: :LikeEvent, foreign_key: :member_id
  has_many :likes_events , through: :like_event_likes, source: :event

  has_many :recommend_event_recommends, class_name: :RecommendEvent, foreign_key: :member_id
  has_many :recommend_events , through: :recommend_event_recommends, source: :event

  has_many :comments,  class_name: :Comment, foreign_key: :author_id
  has_many :testimonials, class_name: :Testimonial, foreign_key: :author_id

  def events
    Event
    .events_by_member(self.id)
  end

  def next_events(time = Time.now)
    Event
    .events_by_member(self.id)
    .where('begin_at >= ?', time)
  end

  def past_events(time = Time.now)
    Event
    .events_by_member(self.id)
    .where('begin_at < ?', time)
    .reverse
  end

  def workshops
    Event
    .workshops_by_member(self.id)
  end

  def next_workshops(time = Time.now)
    Event
    .workshops_by_member(self.id)
    .where('begin_at >= ?', time)
  end

  def past_workshops(time = Time.now)
    Event
    .workshops_by_member(self.id)
    .where('begin_at < ?', time)
    .reverse
  end


  def showed_testimonials
    self.testimonials.published
  end

  def self.pseudos
    tab = []
    Member.all.each do |m|
      tab << m.pseudo.to_s
    end
    return tab
  end


  def self.pros
    pros = Member.with_role(:professional).order(pseudo: :desc).uniq
  end

  # to be use in heroku run rails c
  def self.valid_list
    valid_list = []
    Member.all.each do |m|
      valid_list <<= m if m.valid?
    end
    return valid_list
  end

  # to be use in heroku run rails c
  def self.not_valid_list
    not_valid_list = []
    Member.all.each do |m|
      not_valid_list <<= m if !m.valid?
    end
    return not_valid_list
  end

  def self.from_email(email)
    where(email: email).first
  end

  def self.from_facebook(facebook_id)
    where(facebook_id: facebook_id).first
  end

  def self.new_with_session(params, session)
    super.tap do |member|
      if facebook_data = session['devise.facebook_data']
        member.facebook_id = facebook_data['uid']
        member.email = facebook_data['info']['email']
        member.password = member.password_confirmation = Devise.friendly_token
        session['facebook_login'] = 1
      end
    end
  end

  def url
     return ENV["ROOT_URL"] + '/members/' + self.id.to_s
  end

  def male?
    return self.gender == MEMBER_GENDER_MALE
  end

  def female?
    return self.gender == MEMBER_GENDER_FEMALE
  end

end
