class AddIndexCreatedAtAndDurationInSecondSleepRecordTable < ActiveRecord::Migration[7.1]
  def up
    add_index :sleep_records, :created_at

    add_index :sleep_records, :duration_in_second, where: "duration_in_second is not null"
  end

  def down
    remove_index :sleep_records, :duration_in_second

    remove_index :sleep_records, :created_at
  end
end
