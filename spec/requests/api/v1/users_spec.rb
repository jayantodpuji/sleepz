require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  let!(:user_verde) { User.create!(name: "Verde") }
  let!(:user_john) { User.create!(name: "John") }
  let!(:user_jane) { User.create!(name: "Jane") }
  let!(:user_kana) { User.create!(name: "Kana") }

  before do
    Follow.create!(follower: user_verde, followed: user_john)
    Follow.create!(follower: user_verde, followed: user_jane)

    john_sleep_time = 1.week.ago + 1.day
    user_john.sleep_records.create!(sleep_time: john_sleep_time, wake_time: john_sleep_time + 5.hours)

    jane_sleep_time = Time.current - 2.days
    user_jane.sleep_records.create!(sleep_time: jane_sleep_time, wake_time: jane_sleep_time + 3.hours)
  end

  describe "GET /api/v1/users/:id/timeline" do
    context "when user has followers with sleep records" do
      it "returns http status OK" do
        get "/api/v1/users/#{user_verde.id}/timeline"

        expect(response).to have_http_status(:ok)

        sleep_records = JSON.parse(response.body)["data"]

        expect(sleep_records.size).to eq(2)

        durations = sleep_records.map { |record| record["duration_in_second"] }
        expect(durations).to eq(durations.sort.reverse)
      end
    end

    context "when user has no followers with sleep records" do
      it "returns an empty array" do
        get "/api/v1/users/#{user_kana.id}/timeline"

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["data"]).to be_empty
      end
    end
  end
end
