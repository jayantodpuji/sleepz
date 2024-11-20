=begin
  sleep_records table is to track when user sleep and wake up and calculate the duration in second
  we force the record to have sleep_time first before wake_time
=end
class CreateSleepRecords < ActiveRecord::Migration[7.1]
  def up
    create_table :sleep_records do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :sleep_time, null: false
      t.datetime :wake_time,  null: true
      t.integer :duration_in_second, null: true
      t.datetime :created_at, null: false, default: -> { "current_timestamp" }
    end
  end

  def down
    drop_table :sleep_records
  end
end
