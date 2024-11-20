class Api::V1::UserActionsController < ApplicationController
  def create
    user = User.find(create_action_params[:user_id])
    user_actions = user.user_actions.order(:created_at)
    if user_actions.size > 0
      last_user_action = user_actions.last
      if last_user_action && last_user_action.action == create_action_params[:user_action]
        render json: { error: "Invalid action. Last action was also #{create_action_params[:user_action]}" }, status: :unprocessable_entity
        return
      end
    end

    user.user_actions.create!(action: create_action_params[:user_action], action_time: create_action_params[:user_action_time])
    render json: user_actions, status: :ok
  rescue => e
    Rails.logger.error("Error creating user action: #{e.message}")
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private def create_action_params
    params.permit(:user_id, :user_action, :user_action_time)
  end
end
