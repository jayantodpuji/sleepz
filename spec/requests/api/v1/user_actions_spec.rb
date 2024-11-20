require 'rails_helper'

RSpec.describe "Api::V1::UserActionsController", type: :request do
  let!(:user) { User.create!(name: "Verde") }

  describe "POST /api/v1/user_actions" do
    context "when the user has no previous actions" do
      it "creates a new user action" do
        post "/api/v1/user_actions", params: { user_id: user.id, user_action: "sleep", user_action_time: Time.current }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).length).to eq(1)
      end
    end

    context "when the user already has previous actions" do
      before do
        user.user_actions.create!(action: "sleep", action_time: Time.current - 24.hour)
        user.user_actions.create!(action: "awake", action_time: Time.current - 23.hour)
      end

      it "creates a new user action if it is a valid transition" do
        post "/api/v1/user_actions", params: { user_id: user.id, user_action: "sleep", user_action_time: Time.current }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).length).to eq(3)
      end

      it "returns an error if the last action is the same as the new action" do
        post "/api/v1/user_actions", params: { user_id: user.id, user_action: "awake", user_action_time: Time.current }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ "error" => "Invalid action. Last action was also awake" })
      end

      it "returns actions ordered by created_at ascending after creating a new action" do
        post "/api/v1/user_actions", params: { user_id: user.id, user_action: "sleep", user_action_time: Time.current }

        expect(response).to have_http_status(:ok)

        user_actions = JSON.parse(response.body)

        created_at_times = user_actions.map { |action| action["created_at"] }
        expect(created_at_times).to eq(created_at_times.sort)
      end
    end
  end
end
