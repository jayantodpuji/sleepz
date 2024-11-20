class User < ApplicationRecord
  validates :name, presence: true

  has_many :user_actions
end
