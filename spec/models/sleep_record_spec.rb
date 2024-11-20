require 'rails_helper'

RSpec.describe SleepRecord, type: :model do
  let!(:user) { User.create!(name: "Verde") }

  context "with valid attributes" do
    it "produces valid record" do
      sleep_record = SleepRecord.new(user: user, sleep_time: Time.current, wake_time: Time.current)
      expect(sleep_record.valid?).to eq(true)
    end

    it "produces valid record without wake_time" do
      sleep_record = SleepRecord.new(user: user, sleep_time: Time.current)
      expect(sleep_record.valid?).to eq(true)
    end

    it "produces valid record with duration_in_second" do
      sleep_record = SleepRecord.new(user: user, wake_time: Time.current, sleep_time: Time.current - 1.hour)
      expect(sleep_record.valid?).to eq(true)

      sleep_record.save!
      expect(sleep_record.duration_in_second).to eq(3599) # 1 hour in seconds
    end
  end

  context "with invalid sleep_time" do
    it "produces invalid record" do
      sleep_record = SleepRecord.new(user: user)
      expect(sleep_record.valid?).to eq(false)
    end
  end
end
