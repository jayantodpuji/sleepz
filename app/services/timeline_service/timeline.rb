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
      following_ids = fetch_following_ids
      return SleepRecord.none if following_ids.empty?

      sleep_record_ids = fetch_sleep_record_ids(following_ids)
      return SleepRecord.none if sleep_record_ids.empty?

      fetch_sleep_records(sleep_record_ids)
    end

    private def fetch_following_ids
      cache_key = "users/#{user_id}/followings"
      Rails.cache.fetch(cache_key, expires_in: Constants::FOLLOWING_IDS_CACHE_DURATION) do
        Follow.where(follower_id: user_id).pluck(:followed_id)
      end
    end

    private def fetch_sleep_record_ids(following_ids)
      cache_key = "timeline/#{user_id}/following_count_#{following_ids.length}"
      Rails.cache.fetch(cache_key, expires_in: Constants::TIMELINE_CACHE_DURATION) do
        SleepRecord
          .where(user_id: following_ids)
          .where("created_at >= ?", Constants::RECORDS_TIME_WINDOW.ago)
          .where.not(duration_in_second: nil)
          .order(duration_in_second: :desc)
          .pluck(:id)
      end
    end

    private def fetch_sleep_records(sleep_record_ids)
      SleepRecord
        .includes(:user)
        .where(id: sleep_record_ids)
        .order(duration_in_second: :desc)
        .page(page)
        .per(per)
    end
  end
end
