class UserSerializer
include JSONAPI::Serializer

  attributes :first_name, :last_name, :email, :address, :lat, :lon, :is_remote, :skills, :meetings

  attribute :skills do |user|
    user.skills.map do |skill|
      {
        id: skill.id,
        name: skill.name,
        proficiency: skill.proficiency
      }
    end
  end

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