require 'rails_helper'

RSpec.describe "Api::V1::FollowsController", type: :request do
  let!(:user_alice) { User.create!(name: "Alice") }
  let!(:user_bob) { User.create!(name: "Bob") }

  describe "POST /api/v1/follows" do
    context "when valid params are provided" do
      it "creates a new follow relationship and returns no content" do
        post "/api/v1/follows", params: { follower_id: user_alice.id, followed_id: user_bob.id }

        expect(response).to have_http_status(:no_content)
        expect(Follow.count).to eq(1)
        expect(Follow.first.follower).to eq(user_alice)
        expect(Follow.first.followed).to eq(user_bob)
      end
    end

    context "when follower tries to follow themselves" do
      it "returns unprocessable entity" do
        post "/api/v1/follows", params: { follower_id: user_alice.id, followed_id: user_alice.id }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("You cannot follow yourself")
      end
    end

    context "when a follower or followed user does not exist" do
      it "returns unprocessable entity if follower does not exist" do
        post "/api/v1/follows", params: { follower_id: 999, followed_id: user_bob.id }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Follower not found")
      end

      it "returns unprocessable entity if followed user does not exist" do
        post "/api/v1/follows", params: { follower_id: user_alice.id, followed_id: 999 }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Followed user not found")
      end
    end

    context "when invalid params are provided" do
      it "returns unprocessable entity when follower_id is missing" do
        post "/api/v1/follows", params: { followed_id: user_bob.id }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Follower not found")
      end

      it "returns unprocessable entity when followed_id is missing" do
        post "/api/v1/follows", params: { follower_id: user_alice.id }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Followed user not found")
      end
    end
  end
end
