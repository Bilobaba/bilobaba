require 'pry'

class Tag < ApplicationRecord
  has_many :taggings
  has_many :tags, through: :taggings

  def self.topics
    tabs = []
    Tagging.all.each do |t|
        tabs << t.tag.name if t.context == "topics"
    end
    return tabs.uniq.sort
  end

  def self.categories
    tabs = []
    Tagging.all.each do |t|
        tabs << t.tag.name if t.context == "categories"
    end
    return tabs.uniq.sort
  end

  def self.rename(a,b)
    t = Tag.find_by_name(a)
    if t
      t.update!(name: b)
    end
  end
end
