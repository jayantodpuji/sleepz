module Api
  module V1
    class FollowsController < ApplicationController
      def create
        follower = User.find_by(id: follow_params[:follower_id])
        followed = User.find_by(id: follow_params[:followed_id])

        if follower.nil?
          return render json: { error: "Follower not found" }, status: :unprocessable_entity
        end

        if followed.nil?
          return render json: { error: "Followed user not found" }, status: :unprocessable_entity
        end

        if follower.id == followed.id
          return render json: { error: "You cannot follow yourself" }, status: :unprocessable_entity
        end

        Follow.create!(follower: follower, followed: followed)
        head :no_content
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      private def follow_params
        params.permit(:follower_id, :followed_id)
      end
    end
  end
end
