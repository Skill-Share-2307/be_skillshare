require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  describe 'GET /api/v1/users/:user_id' do
    it 'returns user information' do
      user = create(:user, is_remote: true)
      get "/api/v1/users/#{user.id}"
      expect(response).to have_http_status(200)

      data = JSON.parse(response.body)
      expect(data).to have_key('data')

      user_data = data['data']
      expect(user_data).to be_a(Hash)
      expect(user_data).to have_key('id')
      expect(user_data).to have_key('type')
      expect(user_data).to have_key('attributes')

      user_attributes = user_data['attributes']
      expect(user_attributes).to have_key('first_name')
      expect(user_attributes).to have_key('last_name')
      expect(user_attributes).to have_key('email')
      expect(user_attributes).to have_key('address')
      expect(user_attributes).to have_key('lat')
      expect(user_attributes).to have_key('lon')
      expect(user_attributes).to have_key('is_remote')
    end
  end
end