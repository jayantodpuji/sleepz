module Api
  module V1
    class UsersController < ApplicationController
      def timeline
        timeline_sleep_records = TimelineService::Timeline.call(
          params[:id],
          params[:page] || 1,
          params[:per] || 10,
        )

        render json: SleepRecordSerializer.new(
          timeline_sleep_records,
          meta: {
            pagination: {
              current_page: timeline_sleep_records.current_page,
              next_page: timeline_sleep_records.next_page,
              prev_page: timeline_sleep_records.prev_page,
              total_pages: timeline_sleep_records.total_pages,
              total_count: timeline_sleep_records.total_count
            }
          }
        ).serializable_hash, status: :ok
      rescue TimelineService::UserNotFoundError => e
        render json: { error: e.message }, status: :unprocessable_entity
      rescue StandardError
        render json: { error: 'An unexpected error occurred. Please try again later.' }, status: :internal_server_error
      end
    end
  end
end
