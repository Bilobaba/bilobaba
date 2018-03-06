class Testimonial < ApplicationRecord

  mount_uploader :image, ImageUploader

  belongs_to :member
end
