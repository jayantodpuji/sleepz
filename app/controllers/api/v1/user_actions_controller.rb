class Api::V1::UserActionsController < ApplicationController
  def create
    user = User.find(create_action_params[:user_id])

    user_sleep_records = user.sleep_records
    if user_sleep_records.size == 0 && create_action_params[:user_action] == "awake"
      render json: { error: "invalid action. user does not have sleep record" }, status: :unprocessable_entity
      return
    end

    if user_sleep_records.size > 0
      last_sleep_record = user_sleep_records.last
      if last_sleep_record.wake_time == null && create_action_params[:user_action] == "sleep"
        render json: { error: "invalid action. user can't track sleep time again" }, status: :unprocessable_entity
        return
      end

      if last_sleep_record.wake_time != null && last_sleep_record.sleep_time != null && create_action_params[:user_action] == "awake"
        render json: { error: "invalid action. user can't track awake time" }, status: :unprocessable_entity
        return
      end
    end

    user_actions = user.user_actions.order(:created_at)
    if user_actions.size == 0 && create_action_params[:user_action] == "awake"
      render json: { error: "invalid action. user can't do awake yet" }, status: :unprocessable_entity
    end

    if user_actions.size > 0
      last_user_action = user_actions.last
      if last_user_action && last_user_action.action == create_action_params[:user_action]
        render json: { error: "Invalid action. Last action was also #{create_action_params[:user_action]}" }, status: :unprocessable_entity
        return
      end
    end

    user.user_actions.create!(action: create_action_params[:user_action], action_time: create_action_params[:user_action_time])
    if create_action_params[:user_action] == "sleep"
      user.sleep_records.create!(sleep_time: create_action_params[:user_action_time])
    else
      last_sleep_record = user_sleep_records.last
      last_sleep_record.wake_time = create_action_params[:user_action_time]
      last_sleep_record.save!
    end

    render json: user_actions, status: :ok
  rescue => e
    Rails.logger.error("Error creating user action: #{e.message}")
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private def create_action_params
    params.permit(:user_id, :user_action, :user_action_time)
  end
end
