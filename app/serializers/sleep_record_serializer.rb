class SleepRecordSerializer
  include JSONAPI::Serializer

  attribute :duration_in_second

  attribute :user_display_name do |object|
    object.user.name
  end

  attribute :created_at

  cache_options store: Rails.cache, namespace: 'sleep_record_serializer', expires_in: 3.minutes
end
