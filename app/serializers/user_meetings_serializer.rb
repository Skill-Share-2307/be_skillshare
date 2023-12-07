class UserMeetingsSerializer
  include JSONAPI::Serializer
  attributes :meetings

  attribute :meetings do |user|
    user.meetings.map do |meeting|
      {
        id: meeting.id,
        date: meeting.date,
        start_time: meeting.start_time,
        end_time: meeting.end_time,
        is_accepted: meeting.is_accepted,
        purpose: meeting.purpose
      }
    end
  end
end