class Comment < ApplicationRecord
  belongs_to :author, class_name: 'Member'
  belongs_to :event, class_name: 'Event', optional: true
  belongs_to :commentable, polymorphic: true, optional: true
end
