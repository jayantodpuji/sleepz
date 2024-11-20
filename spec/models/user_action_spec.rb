require 'rails_helper'

RSpec.describe UserAction, type: :model do
  let (:user) { User.create!(name:"Verde") }

  context "with valid attributes" do
    it "produces a valid record" do
      action = UserAction.new(user: user, action: "sleep", action_time: Time.current)

      expect(action.valid?).to eq(true)
    end
  end

  context "with invalid attributes" do
    it "is invalid without a user" do
      action = UserAction.new(user: nil, action: "sleep", action_time: Time.current)

      expect(action.valid?).to eq(false)
    end

    it "is invalid without an action" do
      action = UserAction.new(user: user, action: nil, action_time: Time.current)

      expect(action.valid?).to eq(false)
    end

    it "is invalid with non allowed action" do
      action = UserAction.new(user: user, action: "yapping", action_time: Time.current)

      expect(action.valid?).to eq(false)
    end

    it "is invalid without an action_time" do
      user = User.create!(name: "Verde")
      action = UserAction.new(user: user, action: "sleep", action_time: nil)

      expect(action.valid?).to eq(false)
    end
  end
end
