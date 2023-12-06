class MeetingSerializer
include JSONAPI::Serializer
  
  attributes :date, :start_time, :end_time, :is_accepted, :purpose, :partner_id, :user_id
end