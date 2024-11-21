require 'rails_helper'

RSpec.describe "Api::V1::UserActionsController", type: :request do
  let!(:user) { User.create!(name: "Verde") }

  describe "POST /api/v1/user_actions" do
    describe "user has no previous records" do
      context "when user register sleep action" do
        it "returns http status OK and user_actions history data" do
          post "/api/v1/user_actions", params: { user_id: user.id, user_action: "sleep", user_action_time: Time.current.iso8601 }

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body).length).to eq(1)

          sleep_records = user.sleep_records
          expect(sleep_records.count).to eq(1)
          expect(sleep_records.first.sleep_time).to be_present
          expect(sleep_records.first.wake_time).to be_nil
          expect(sleep_records.first.duration_in_second).to be_nil

          user_actions = user.user_actions
          expect(user_actions.count).to eq(1)
          expect(user_actions.first.action).to eq("sleep")
        end
      end

      context "when user register awake action" do
        it "returns unprocessable_content" do
          post "/api/v1/user_actions", params: { user_id: user.id, user_action: "awake", user_action_time: Time.current.iso8601 }
          expect(response).to have_http_status(:unprocessable_content)
        end
      end
    end

    describe "user has previous records" do
      describe "user last action is sleep" do
        before do
          action_time = (Time.current - 24.hour).iso8601
          user.user_actions.create!(action: "sleep", action_time: action_time)
          user.sleep_records.create!(sleep_time: action_time)
        end

        context "when user register awake action" do
          it "returns http status OK and user_actions history data" do
            post "/api/v1/user_actions", params: { user_id: user.id, user_action: "awake", user_action_time: Time.current.iso8601 }

            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)["data"].length).to eq(2)
          end
        end

        context "when user register sleep action" do
          it "returns unprocessable_content" do
            post "/api/v1/user_actions", params: { user_id: user.id, user_action: "sleep", user_action_time: Time.current.iso8601 }
            expect(response).to have_http_status(:unprocessable_content)
          end
        end
      end

      describe "user last action is awake" do
        before do
          action_time = Time.current
          user.user_actions.create!(action: "awake", action_time: action_time)
          user.sleep_records.create!(sleep_time: action_time - 20.hours, wake_time: action_time)
        end

        context "when user register sleep action" do
          it "returns http status OK and user_actions history data" do
            post "/api/v1/user_actions", params: { user_id: user.id, user_action: "sleep", user_action_time: Time.current.iso8601 }
            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)["data"].length).to eq(2)
          end
        end

        context "when user register awake action" do
          it "returns unprocessable_content" do
            post "/api/v1/user_actions", params: { user_id: user.id, user_action: "awake", user_action_time: Time.current.iso8601 }
            expect(response).to have_http_status(:unprocessable_content)
          end
        end
      end
    end
  end
end
