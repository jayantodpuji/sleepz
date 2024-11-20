class UserAction < ApplicationRecord
  belongs_to :user

  validates :action, presence: true, inclusion: { in: %w[sleep awake] }
  validates :action_time, presence: true
end
