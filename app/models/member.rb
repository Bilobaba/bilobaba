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

  has_many :comments
  has_many :testimonials

  def next_events_organize
    organize_events
      .order(begin_at: :asc)
      .where('begin_at >= ?', Time.now)
      .includes(:attendees)
  end

  def past_events_organize
    organize_events
      .order(begin_at: :desc)
      .where('begin_at <= ?', Time.now)
      .includes(:attendees)
  end

  def next_events_teach
    teach_events
      .order(begin_at: :asc)
      .where('begin_at >= ?', Time.now)
      .includes(:attendees)
  end

  def past_events_teach
    teach_events
      .order(begin_at: :desc)
      .where('begin_at <= ?', Time.now)
      .includes(:attendees)
  end

  def next_events_t_o #teach or organize
    (next_events_organize + next_events_teach).uniq
  end

  def past_events_t_o #teach or organize
    (past_events_organize + past_events_teach).uniq
  end

  def next_events_attend
    attend_events
      .order(begin_at: :asc)
      .where('begin_at >= ?', Time.now)
      .includes(:attendees)
  end

  def testimonials_showed
    self.testimonials.where(published: true)
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
end
