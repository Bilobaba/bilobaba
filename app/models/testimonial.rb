class Testimonial < ApplicationRecord

  include Rails.application.routes.url_helpers
  include AlgoliaSearch

  acts_as_taggable_on :topics, :members

  mount_uploader :image, ImageUploader

  belongs_to :author, class_name: 'Member'

  has_many :comments, as: :commentable


  scope :published, -> { where(published: true) }

  def self.showed
    if member_signed_in?
      list = (Testimonial.published + current_member.testimonials).uniq
    else
      list = Testimonial.published
    end
    return list
  end

  def member_name
    self.author.name
  end

  def member_first_name
    self.author.first_name
  end

  def member_avatar
    return self.author.avatar.url
  end

  def member_pseudo
    return self.author.pseudo
  end

  def member_bio
    return self.author.bio
  end

  def url
     return ENV["ROOT_URL"] + testimonial_path(self)
  end

  def written_at
    I18n.l(self.created_at, format: '%a %-d %b %Y')
  end
end
