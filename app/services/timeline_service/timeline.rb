require_relative "errors"
module TimelineService
  class Timeline < BaseService
    attr_reader :user_id, :page, :per
    def initialize(user_id, page, per)
      @user_id = user_id
      @page = page
      @per = per
    end

    def call
      user = User.find_by(id: user_id)
      raise UserNotFoundError, "User not found" unless user

      sleep_records = SleepRecord
        .includes([:user])
        .where(user_id: user.followings.pluck(:followed_id))
        .where('created_at >= ?', 1.week.ago)
        .order(duration_in_second: :desc)
        .page(page)
        .per(per)

      sleep_records
    end
  end
end
