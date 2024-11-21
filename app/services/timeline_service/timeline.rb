require_relative "errors"
module TimelineService
  class Timeline < BaseService
    attr_reader :user_id
    def initialize(user_id)
      @user_id = user_id
    end

    def call
      user = User.find_by(id: user_id)
      raise UserNotFoundError, "User not found" unless user

      sleep_records = SleepRecord
        .where(user_id: user.followings.pluck(:followed_id))
        .where('created_at >= ?', 1.week.ago)
        .order(duration_in_second: :desc)

      sleep_records
    end
  end
end
