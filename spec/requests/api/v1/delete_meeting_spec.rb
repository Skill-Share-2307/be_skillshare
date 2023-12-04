require 'rails_helper'

RSpec.describe 'Meetings API', type: :request do
  describe 'DELETE /api/v1/meetings/:meeting_id' do
    it 'deletes the meeting' do
      user = create(:user)
      partner = create(:user)
      meeting = create(:meeting)

      UserMeeting.create(user: user, meeting: meeting, is_requestor: true)
      UserMeeting.create(user: partner, meeting: meeting, is_requestor: false)

      expect(Meeting.count).to eq(1)
      expect(UserMeeting.count).to eq(2)

      delete "/api/v1/meetings/#{meeting.id}"

      expect(response).to be_successful
      expect(response.status).to eq(204)

      expect(Meeting.count).to eq(0)
      expect(UserMeeting.count).to eq(0)
    end

    it 'returns an error if the meeting is not found' do
      delete "/api/v1/meetings/999"

      expect(response).to have_http_status(:not_found)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to_not have_key(:data)
      expect(data).to have_key(:error)
      expect(data[:error]).to eq("Meeting not found.")
    end
  end
end
