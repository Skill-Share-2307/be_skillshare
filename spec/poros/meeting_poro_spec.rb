require 'rails_helper'

RSpec.describe MeetingPoro do
  it "exists and has attributes" do
    current_user = User.create!(first_name: "Chicken", last_name: "Bird", email: "chicken@gmail.com", street: "1234 Street", city: "CO springs", state: "CO", zipcode: "12345", lat: 1.12, lon: 1.12, is_remote: false, about: "I enjoy long walks on the beach")
    found_user = User.create!(first_name: "Kiwi", last_name: "Bird", email: "kiwi@gmail.com", street: "1234 Street", city: "CO springs", state: "CO", zipcode: "12345", lat: 1.25, lon: 1.32, is_remote: false, about: "I enjoy long walks on the beach")
    meeting = Meeting.create!(date: "2023-12-15", start_time: "07:30", end_time: "08:00", purpose: "testing")
    UserMeeting.create!(user_id: current_user.id, meeting_id: meeting.id, is_requestor: true)
    UserMeeting.create!(user_id: found_user.id, meeting_id: meeting.id, is_requestor: false)

    poro = MeetingPoro.new(meeting, current_user.id)
    expect(poro).to be_a MeetingPoro
    expect(poro.id).to eq(meeting.id)
    expect(poro.date).to eq(meeting.date)
    expect(poro.start_time).to eq(meeting.start_time)
    expect(poro.end_time).to eq(meeting.end_time)
    expect(poro.purpose).to eq(meeting.purpose)
    expect(poro.partner_id).to eq(found_user.id)
    expect(poro.is_accepted).to eq(meeting.is_accepted)
  end
end