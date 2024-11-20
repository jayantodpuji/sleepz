require_relative "errors"
module UserActionService
  class RegisterAction < BaseService
    attr_reader :user, :user_action, :action_time
    attr_reader :sleep_records, :user_actions

    def initialize(user, user_action, action_time)
      @user = user
      @user_action = user_action
      @action_time = action_time

      @sleep_records = user.sleep_records
      @user_actions = user.user_actions.order(:created_at)
    end

    def call
      validate_user_action!

      ActiveRecord::Base.transaction do
        create_user_actions
        handle_sleep_records
      end

      @user_actions.reload
    end

    private def handle_sleep_records
      if is_sleep_request?
        sleep_records.create!(sleep_time: action_time)
      else
        last_sleep_record = sleep_records.last
        last_sleep_record.update!(wake_time: action_time)
      end
    end

    private def create_user_actions
      user_actions.create!(action: user_action, action_time: action_time)
    end

    private def validate_user_action!
      validate_no_sleep_records   if is_awake_request?
      validate_last_sleep_record  if sleep_records.any?
      validate_last_user_action   if user_actions.any?
    end

    private def validate_no_sleep_records
      if sleep_records.empty?
        raise InvalidActionError, "Invalid action. User does not have a sleep record."
      end
    end

    private def validate_last_sleep_record
      last_sleep_record = sleep_records.last
      if last_sleep_record.wake_time.nil? && is_sleep_request?
        raise InvalidActionError, "Invalid action. User can't track sleep time again."
      elsif last_sleep_record.wake_time.present? && is_awake_request?
        raise InvalidActionError, "Invalid action. User can't track awake time."
      end
    end

    private def validate_last_user_action
      last_user_action = user_actions.last
      if last_user_action&.action == user_action
        raise InvalidActionError, "Invalid action. Last action was also #{user_action}."
      end
    end

    private def is_sleep_request?
      user_action == Constants::SLEEP_ACTION
    end

    private def is_awake_request?
      user_action == Constants::AWAKE_ACTION
    end
  end
end
