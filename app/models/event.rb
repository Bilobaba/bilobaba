class Event < ApplicationRecord
  belongs_to :organized_by, class_name: :Member
end
