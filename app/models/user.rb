class User < ApplicationRecord
  validates :name, presence: true

  has_many :user_actions
  has_many :sleep_records

  has_many :followers, class_name: "Follow", foreign_key: "followed_id"
  has_many :followings, class_name: "Follow", foreign_key: "follower_id"
end
