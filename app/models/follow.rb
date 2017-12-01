class Follow < ApplicationRecord
  belongs_to :follower, class_name: :Member
  belongs_to :followee, class_name: :Member
end
