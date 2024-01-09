class UserMeetingSerializer
  include JSONAPI::Serializer
  attributes :date, :start_time, :end_time, :is_accepted, :purpose, :partner_id, :is_host, :partner_name
end