require "faker"

puts "Seed data program"

puts "Delete all data"
Follow.delete_all
UserAction.delete_all
SleepRecord.delete_all
User.delete_all

puts "Seeding started"
users = 20.times.map { User.create!(name: Faker::Name.unique.name) }

users.each do |current_user|
  other_users = users.reject { |user| user == current_user }

  other_users.each do |followed_user|
    Follow.create!(
      follower_id: current_user.id,
      followed_id: followed_user.id
    )
  end
end

users.each do |current_user|
  200.times do
    sleep_time = Faker::Time.between(from: 1.week.ago, to: Time.current).round
    awake_time = sleep_time + rand(1..8).hour

    UserAction.create!(user: current_user, action: "sleep", action_time: sleep_time)
    UserAction.create!(user: current_user, action: "awake", action_time: awake_time)
    SleepRecord.create!(user: current_user, sleep_time: sleep_time, wake_time: awake_time)
  end
end

10.times.map { User.create!(name: Faker::Name.unique.name) }
