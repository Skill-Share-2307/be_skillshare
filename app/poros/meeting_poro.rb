class MeetingPoro
  attr_reader :id,
              :date,
              :start_time,
              :end_time,
              :is_accepted,
              :purpose,
              :partner_id

  def initialize(meeting, user_id)
    @id = meeting.id
    @date = meeting.date
    @start_time = meeting.start_time
    @end_time = meeting.end_time
    @is_accepted = meeting.is_accepted
    @purpose = meeting.purpose
    @partner_id = meeting.get_attendee(user_id)
  end
end