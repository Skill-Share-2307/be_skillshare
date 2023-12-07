class MeetingPoro
  attr_reader :id,
              :date,
              :start_time,
              :end_time,
              :is_accepted,
              :purpose,
              :partner_id,
              :is_host

  def initialize(meeting, user_id)
    @id = meeting.id
    @date = meeting.date
    @start_time = meeting.start_time.strftime("%I:%M %p")
    @end_time = meeting.end_time.strftime("%I:%M %p")
    @is_accepted = meeting.is_accepted
    @purpose = meeting.purpose
    @partner_id = meeting.get_attendee(user_id)
    @is_host = user_id == meeting.host_id
  end
end