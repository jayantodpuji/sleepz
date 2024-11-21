module Api
  module V1
    class FollowsController < ApplicationController
      def create
        follower = User.find(follow_params[:follower_id])
        followed = User.find(follow_params[:followed_id])

        Follow.create!(follower: follower, followed: followed)
        head :no_content
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      private def follow_params
        # TODO: should we use params.require(:follow).permit(:follower_id, :followed_id)? need to research
        params.permit(:follower_id, :followed_id)
      end
    end
  end
end
