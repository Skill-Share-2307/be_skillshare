require 'rails_helper'

RSpec.describe Meeting, type: :model do
  describe 'relationships' do 
    it { should have_many(:user_meetings) }
    it { should have_many(:users).through(:user_meetings) }
  end

  describe "instance methods" do
    describe "#get_attendee" do
      it "returns the other attendee's ID for a given meeting and user ID" do
        current_user = User.create!(first_name: "Chicken", last_name: "Bird", email: "chicken@gmail.com", street: "1234 Street", city: "CO springs", state: "CO", zipcode: "12345", lat: 1.12, lon: 1.12, is_remote: false, about: "I enjoy long walks on the beach")
        found_user = User.create!(first_name: "Kiwi", last_name: "Bird", email: "kiwi@gmail.com", street: "1234 Street", city: "CO springs", state: "CO", zipcode: "12345", lat: 1.25, lon: 1.32, is_remote: false, about: "I enjoy long walks on the beach")
        meeting = Meeting.create!(date: "2023-12-15", start_time: "07:30", end_time: "08:00", purpose: "testing")
        UserMeeting.create!(user_id: current_user.id, meeting_id: meeting.id, is_requestor: true)
        UserMeeting.create!(user_id: found_user.id, meeting_id: meeting.id, is_requestor: false)

        expect(meeting.get_attendee(current_user.id)).to eq(found_user.id)
        expect(meeting.get_attendee(current_user.id)).to_not eq(current_user.id)
      end
    end
  end
end
