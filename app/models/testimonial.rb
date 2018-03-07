class Testimonial < ApplicationRecord

  mount_uploader :image, ImageUploader

  belongs_to :member

  scope :published, -> { where(published: true) }

end
