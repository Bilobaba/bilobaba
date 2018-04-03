class ViewDatum < ApplicationRecord
  validates :data_type, presence: true
  validates :data_type, uniqueness: true

  def self.topics
    v = ViewDatum.find_by_data_type(VIEW_DATA_TOPICS)
    v.content = Tag.topics.sort
    v.save
  end

  def self.members
    v = ViewDatum.find_by_data_type(VIEW_DATA_MEMBERS)
    v.content = Member.pseudos.sort
    v.save
  end

  def self.categories
    v = ViewDatum.find_by_data_type(VIEW_DATA_CATEGORIES)
    v.content = Event.categories.sort
    v.save
  end
end
