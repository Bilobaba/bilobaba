class Event < ApplicationRecord
  belongs_to organizer, class_name: "Member", foreign_key: "member_id"
end
