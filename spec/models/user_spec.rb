require 'rails_helper'

RSpec.describe User, type: :model do
  context "with valid name" do
    it "produces valid record" do
      user = User.new(name: "Verde")
      expect(user.valid?).to eq(true)
    end
  end

  context "with invalid name" do
    it "produces invalid record" do
      user = User.new(name: nil)
      expect(user.valid?).to eq(false)
    end
  end
end
