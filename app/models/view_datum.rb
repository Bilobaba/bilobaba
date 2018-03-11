class ViewDatum < ApplicationRecord
  validates :data_type, presence: true
  validates :data_type, uniqueness: true
end
