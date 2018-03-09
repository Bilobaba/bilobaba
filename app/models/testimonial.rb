class Testimonial < ApplicationRecord

  include Rails.application.routes.url_helpers
  include AlgoliaSearch
  include SimpleHashtag::Hashtaggable

  hashtaggable_attribute :body
  mount_uploader :image, ImageUploader

  belongs_to :member

  scope :published, -> { where(published: true) }


  def member_name
    self.member.name
  end

  def member_first_name
    self.member.first_name
  end

  def member_avatar
    return self.member.avatar.url
  end

  def member_pseudo
    return self.member.pseudo
  end

  def member_bio
    return self.member.bio
  end

  def url
     return ENV["ROOT_URL"] + testimonial_path(self)
  end

end
