module Api
  module V1
    class UserActionsController < ApplicationController
      def create
        current_user = User.find(create_action_params[:user_id])

        updated_user_actions = UserActionService::RegisterAction.call(
          current_user,
          create_action_params[:user_action],
          create_action_params[:user_action_time]
        )

        render json: UserActionSerializer.new(updated_user_actions).serializable_hash, status: :ok
      rescue UserActionService::InvalidActionError => e
        render json: { error: e.message }, status: :unprocessable_entity
      rescue StandardError => e
        render json: { error: e.message }, status: :internal_server_error
      end

      private def create_action_params
        params.permit(:user_id, :user_action, :user_action_time)
      end
    end
  end
end
