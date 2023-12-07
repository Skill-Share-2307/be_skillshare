require 'rails_helper'

RSpec.describe 'User Meetings API', type: :request do
  describe 'GET /api/v1/users/:user_id/meetings' do
    it 'returns information of meetings for a user; it will show same meeting data for each participant' do
      user = create(:user)
      partner = create(:user)
      meeting = create(:meeting, users: [user, partner])

      expect(Meeting.count).to eq(1)
      expect(UserMeeting.count).to eq(2)

      get "/api/v1/users/#{user.id}/meetings"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body, symbolize_names: true)

      meeting_data = data[:data]
      expect(meeting_data).to have_key(:id)
      expect(meeting_data[:id]).to eq("#{user.id}")
      expect(meeting_data).to have_key(:type)
      expect(meeting_data).to have_key(:attributes)

      meeting_attributes = meeting_data[:attributes]
      user_meetings = meeting_attributes[:meetings]
      user_meetings.each do |meeting|
        expect(meeting).to have_key(:id)
        expect(meeting).to have_key(:date)
        expect(meeting).to have_key(:start_time)
        expect(meeting).to have_key(:end_time)
        expect(meeting).to have_key(:is_accepted)
        expect(meeting).to have_key(:purpose)
      end

      get "/api/v1/users/#{partner.id}/meetings"
      expect(response).to have_http_status(200)
      data_2 = JSON.parse(response.body, symbolize_names: true)

      meeting_data_2 = data_2[:data]
      expect(meeting_data_2).to have_key(:id)
      expect(meeting_data_2[:id]).to eq("#{partner.id}")
      expect(meeting_data_2).to have_key(:type)
      expect(meeting_data_2).to have_key(:attributes)

      meeting_attributes_2 = meeting_data_2[:attributes]
      user_meetings_2 = meeting_attributes_2[:meetings]
      user_meetings_2.each do |meeting|
        expect(meeting).to have_key(:id)
        expect(meeting).to have_key(:date)
        expect(meeting).to have_key(:start_time)
        expect(meeting).to have_key(:end_time)
        expect(meeting).to have_key(:is_accepted)
        expect(meeting).to have_key(:purpose)
      end

      expect(meeting_attributes_2).to eq(meeting_attributes)
    end

    it 'will return an empty array if user has no meetings' do 
      user = create(:user)

      get "/api/v1/users/#{user.id}/meetings"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body, symbolize_names: true)

      meeting_data = data[:data]
      expect(meeting_data).to have_key(:attributes)

      meeting_attributes = meeting_data[:attributes]
      user_meetings = meeting_attributes[:meetings]
      expect(user_meetings).to eq([])
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