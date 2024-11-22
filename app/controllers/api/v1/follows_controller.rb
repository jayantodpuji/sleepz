module Api
  module V1
    class FollowsController < ApplicationController
      def create
        FollowService::CreateFollow.call(follow_params[:follower_id], follow_params[:followed_id])

        head :no_content
      rescue FollowService::UserNotFoundError, FollowService::InvalidActionError => e
        render json: { error: e.message }, status: :unprocessable_entity
      rescue StandardError => e
        render json: { error: e.message }, status: :internal_server_error
      end

      private def follow_params
        params.permit(:follower_id, :followed_id)
      end
    end
  end
end
