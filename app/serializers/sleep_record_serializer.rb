class SleepRecordSerializer
  include JSONAPI::Serializer

  attribute :duration_in_second

  attribute :user_display_name do |object|
    object.user.name
  end

  attribute :created_at
end
