class MeetingSerializer
include JSONAPI::Serializer
  attributes :date, :start_time, :end_time, :is_accepted, :purpose, :partner_id

  attribute :start_time do |meeting|
    meeting.start_time.strftime("%I:%M %p")
  end

  attribute :end_time do |meeting|
    meeting.end_time.strftime("%I:%M %p")
  end
end