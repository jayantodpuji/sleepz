class Api::V1::UserActionsController < ApplicationController
  def create
    current_user = User.find(create_action_params[:user_id])

    updated_user_actions = UserActionService::RegisterAction.call(
      current_user,
      create_action_params[:user_action],
      create_action_params[:user_action_time]
    )
    render json: updated_user_actions, status: :ok
  rescue UserActionService::InvalidActionError => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue StandardError
    render json: { error: 'An unexpected error occurred. Please try again later.' }, status: :internal_server_error
  end

  private def create_action_params
    params.permit(:user_id, :user_action, :user_action_time)
  end
end
