class SleepRecord < ApplicationRecord
  belongs_to :user

  validates :sleep_time, presence: true

  before_save :calculate_duration_in_seconds

  private def calculate_duration_in_seconds
    self.duration_in_second = (wake_time - sleep_time).to_i if sleep_time.present? && wake_time.present?
  end
end
