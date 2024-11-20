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
  end
end
