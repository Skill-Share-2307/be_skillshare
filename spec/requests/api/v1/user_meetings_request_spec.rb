require 'rails_helper'

RSpec.describe 'User Meetings API', type: :request do
  describe 'GET /api/v1/users/:user_id/meetings', :vcr do
    it 'returns information of meetings for a user; it will show same meeting data for each participant' do
      user = create(:user)
      partner = create(:user)
      new_meeting = create(:meeting, users: [user, partner])

      expect(Meeting.count).to eq(1)
      expect(UserMeeting.count).to eq(2)
      UserMeeting.first.update(is_requestor: true)

      get "/api/v1/users/#{user.id}/meetings"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body, symbolize_names: true)

      meeting_data = data[:data]
      meeting_data.each do |meeting|
        expect(meeting).to have_key(:id)
        expect(meeting[:id]).to eq(new_meeting.id.to_s)
        expect(meeting).to have_key(:type)
        expect(meeting).to have_key(:attributes)

        meeting_attributes = meeting[:attributes]
        expect(meeting_attributes).to have_key(:date)
        expect(meeting_attributes).to have_key(:start_time)
        expect(meeting_attributes).to have_key(:end_time)
        expect(meeting_attributes).to have_key(:is_accepted)
        expect(meeting_attributes).to have_key(:purpose)
        expect(meeting_attributes).to have_key(:partner_id)
        expect(meeting_attributes).to have_key(:is_host)
      end

      get "/api/v1/users/#{partner.id}/meetings"
      expect(response).to have_http_status(200)
      data_2 = JSON.parse(response.body, symbolize_names: true)

      meeting_data_2 = data_2[:data]
      meeting_data_2.each do |meeting|
        expect(meeting).to have_key(:id)
        expect(meeting[:id]).to eq(new_meeting.id.to_s)
        expect(meeting).to have_key(:type)
        expect(meeting).to have_key(:attributes)

        meeting_attributes_2 = meeting[:attributes]
        expect(meeting_attributes_2).to have_key(:date)
        expect(meeting_attributes_2).to have_key(:start_time)
        expect(meeting_attributes_2).to have_key(:end_time)
        expect(meeting_attributes_2).to have_key(:is_accepted)
        expect(meeting_attributes_2).to have_key(:purpose)
        expect(meeting_attributes_2).to have_key(:partner_id)
        expect(meeting_attributes_2).to have_key(:is_host)
      end
    end

    it 'will also show the partners name in the meeting data' do
      user = create(:user)
      partner = create(:user)
      new_meeting = create(:meeting, users: [user, partner])

      expect(Meeting.count).to eq(1)
      expect(UserMeeting.count).to eq(2)
      UserMeeting.first.update(is_requestor: true)

      get "/api/v1/users/#{user.id}/meetings"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body, symbolize_names: true)

      meeting_data = data[:data]
      expect(meeting_data[:attributes]).to have_key(:partner_name)
    end

    it 'will return an empty array if user has no meetings' do 
      user = create(:user)

      get "/api/v1/users/#{user.id}/meetings"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data).to be_a Hash
      expect(data).to have_key(:data)
      expect(data[:data]).to be_an Array
      expect(data[:data]).to be_empty
    end

    it 'returns an error message if a user is not found' do 
      get "/api/v1/users/1/meetings"
      expect(response).to have_http_status(404)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to_not have_key(:data)
      expect(data).to have_key(:error)
      expect(data[:error]).to eq("User not found.")
    end
  end
end