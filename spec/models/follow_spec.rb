require 'rails_helper'

RSpec.describe Follow, type: :model do
  let! (:user_verde) { User.create!(name:"Verde") }
  let! (:user_anita) { User.create!(name:"Anita") }

  context "with valid attributes" do
    it "produces a valid record" do
      follow = Follow.new(follower: user_verde, followed: user_anita)
      expect(follow.valid?).to eq(true)
    end
  end

  context "with invalid attributes" do
    it "produces an invalid record when following self" do
      follow = Follow.new(follower: user_verde, followed: user_verde)
      expect(follow.valid?).to eq(false)
    end

    it "produces an invalid record when follower_id and followed_id are not unique" do
      Follow.create!(follower: user_verde, followed: user_anita)
      duplicate_follow = Follow.new(follower: user_verde, followed: user_anita)
      expect(duplicate_follow.valid?).to eq(false)
    end
  end
end
