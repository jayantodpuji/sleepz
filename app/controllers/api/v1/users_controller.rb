module Api
  module V1
    class UsersController < ApplicationController
      def timeline
        timeline_sleep_records = TimelineService::Timeline.call(params[:id])

        render json: timeline_sleep_records, status: :ok
      rescue TimelineService::UserNotFoundError => e
        render json: { error: e.message }, status: :unprocessable_entity
      rescue StandardError
        render json: { error: 'An unexpected error occurred. Please try again later.' }, status: :internal_server_error
      end
    end
  end
end
