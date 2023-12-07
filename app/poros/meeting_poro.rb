class MeetingPoro
  def initialize(meeting, user_id)
    @id = meeting.id
    @date = meeting.date
    @start_time = meeting.start_time
    @end_time = meeting.end_time
    @is_accepted = meeting.is_accepted
    @purpose = meeting.purpose
    @partner_id = Meeting.get_partner_id(meeting.id, user_id)
    @user_id = user_id
  end
end