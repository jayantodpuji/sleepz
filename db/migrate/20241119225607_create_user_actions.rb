class CreateUserActions < ActiveRecord::Migration[7.1]
  def up
    create_table :user_actions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :action, null: false
      t.datetime :action_time, null: false, default: -> { "current_timestamp" }
      t.datetime :created_at, null: false, default: -> { "current_timestamp" }
    end
  end

  def down
    drop_table :user_actions
  end
end
