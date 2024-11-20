class SleepRecord < ApplicationRecord
  belongs_to :user

  validates :sleep_time, presence: true
end
