require 'pry'

class Tag < ApplicationRecord
  has_many :taggings
  has_many :tags, through: :taggings

  def self.topics
    tabs = []
    Tagging.all.each do |t|
      if t.context == "topics"
        tabs << t.tag.name
      end
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
