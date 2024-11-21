class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User", foreign_key: "follower_id"
  belongs_to :followed, class_name: "User", foreign_key: "followed_id"

  validates :follower_id, uniqueness: { scope: :followed_id }
  validate :follower_cannot_follow_self

  private def follower_cannot_follow_self
    if follower_id == followed_id
      errors.add(:followed_id, "You cannot follow yourself")
    end
  end
end
