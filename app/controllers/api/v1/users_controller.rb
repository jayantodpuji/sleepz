module Api
  module V1
    class UsersController < ApplicationController
      def timeline
        current_user = User.find(params[:id])
        current_user_followings = current_user.following

        # TODO: check for N+1
        # TODO: enable pagination
        sleep_records = SleepRecord.where(user_id: current_user_followings.pluck(:followed_id)).where('created_at >= ?', 1.week.ago).order(duration_in_second: :desc)
        render json: sleep_records, status: :ok
      rescue StandardError
        render json: { error: 'An unexpected error occurred. Please try again later.' }, status: :internal_server_error
      end
    end
  end
end
