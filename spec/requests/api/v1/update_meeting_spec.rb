require 'rails_helper'

RSpec.describe 'Meetings API', type: :request do
  describe 'PATCH /api/v1/meetings/:meeting_id' do
    it 'updates the meeting when is_approved is true' do
      user = create(:user)
      partner = create(:user)
      meeting = create(:meeting)
      UserMeeting.create(user: user, meeting: meeting, is_requestor: true)
      UserMeeting.create(user: partner, meeting: meeting, is_requestor: false)

      expect(Meeting.count).to eq(1)

      update_params = { is_approved: 'true' }

      put "/api/v1/meetings/#{meeting.id}", params: update_params

      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:success)
      expect(data[:success]).to eq('Meeting updated successfully. Meeting is accepted.')

      updated_meeting = Meeting.find(meeting.id)
      expect(updated_meeting.is_accepted).to eq(true)
    end

    it 'updates the meeting when is_approved is false' do
      user = create(:user)
      partner = create(:user)
      meeting = create(:meeting, is_accepted: true)
      UserMeeting.create(user: user, meeting: meeting, is_requestor: true)
      UserMeeting.create(user: partner, meeting: meeting, is_requestor: false)

      expect(Meeting.count).to eq(1)

      update_params = { is_approved: 'false' }

      put "/api/v1/meetings/#{meeting.id}", params: update_params

      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:success)
      expect(data[:success]).to eq('Meeting updated successfully. Meeting is not accepted.')

      updated_meeting = Meeting.find(meeting.id)
      expect(updated_meeting.is_accepted).to eq(false)
    end

    it 'returns an error if meeting is not found' do
      update_params = { is_approved: 'true' }

      put "/api/v1/meetings/999", params: update_params

      expect(response).to have_http_status(:not_found)
      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to_not have_key(:success)
      expect(data).to have_key(:error)
      expect(data[:error]).to eq('Meeting not found.')
    end

    it 'returns an error if is_approved parameter is not provided' do
      user = create(:user)
      partner = create(:user)
      meeting = create(:meeting)
      UserMeeting.create(user: user, meeting: meeting, is_requestor: true)
      UserMeeting.create(user: partner, meeting: meeting, is_requestor: false)

      update_params = {}

      put "/api/v1/meetings/#{meeting.id}", params: update_params

      expect(response).to have_http_status(:unprocessable_entity)
      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to_not have_key(:success)
      expect(data).to have_key(:error)
      expect(data[:error]).to eq('Invalid parameter value for is_approved.')
    end
  end
end
