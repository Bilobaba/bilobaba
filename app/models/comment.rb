class Comment < ApplicationRecord
  belongs_to :event, class_name: 'Event'
  belongs_to :autor, class_name: 'Member'
end