class Testimonial < ApplicationRecord

  include Rails.application.routes.url_helpers
  include AlgoliaSearch

  acts_as_taggable_on :topics, :members

  mount_uploader :image, ImageUploader

  belongs_to :author, class_name: 'Member'

  has_many :comments, as: :commentable
  has_many :authors, through: :comments

  scope :published, -> { where(published: true) }

  def self.showed
    if member_signed_in?
      list = (Testimonial.published + current_member.testimonials).uniq
    else
      list = Testimonial.published
    end
    return list
  end

  def self.by(member)
    Testimonial
    .where('author_id = ?', member.id)
  end

  def self.about(member)
    list = []
    Testimonial.published.each do |t|
      if t.member_list.include?(member.pseudo)
        list << t
      end
    end
    return list
  end

  def author_name
    self.author.name
  end

  def author_first_name
    self.author.first_name
  end

  def author_avatar
    return self.author.avatar.url
  end

  def author_pseudo
    return self.author.pseudo
  end

  def author_bio
    return self.author.bio
  end

  def url
     return ENV["ROOT_URL"] + testimonial_path(self)
  end

  def written_at
    I18n.l(self.created_at, format: '%a %-d %b %Y')
  end

  def interested_members
    interested_members = []
    interested_members << self.author
    interested_members += self.authors
    interested_members.uniq!
    return interested_members
  end

end
