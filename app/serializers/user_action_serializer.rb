class UserActionSerializer
  include JSONAPI::Serializer
  attributes :action, :action_time, :created_at
end
