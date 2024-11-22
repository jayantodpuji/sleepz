require_relative "errors"
module FollowService
  class CreateFollow < BaseService
    attr_reader :follower_id, :followed_id, :follower, :followed

    def initialize(follower_id, followed_id)
      @follower_id = follower_id
      @followed_id = followed_id
    end

    def call
      validate_params!
      find_users!
      create_follow_record
    end

    private

    def validate_params!
      raise InvalidActionError, "Follower ID cannot be blank" if follower_id.blank?
      raise InvalidActionError, "Followed ID cannot be blank" if followed_id.blank?
    end

    def find_users!
      @follower = User.find_by(id: follower_id)
      @followed = User.find_by(id: followed_id)

      raise UserNotFoundError, "Follower not found" unless follower
      raise UserNotFoundError, "Followed user not found" unless followed
      raise InvalidActionError, "You cannot follow yourself" if follower.id == followed.id
    end

    def create_follow_record
      Follow.create!(follower: follower, followed: followed)
    rescue ActiveRecord::RecordInvalid => e
      raise InvalidActionError, e.message
    end
  end
end
