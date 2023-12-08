require 'rails_helper'

RSpec.describe "user skills endpoint", type: :request do 
  describe "when I send a post request to '/api/v1/add_skills' ", :vcr do 
    it "creates user skills in the database for the user_id that is passed" do 
      user1 = create(:user, id: 1)
      
      skill_info = {
        "user_id": "1",
        "skills": [
          {
            "name": "skiing",
            "proficiency": "1"
          },
          {
            "name": "ping pong",
            "proficiency": "4"
          }
        ]
      }

      post "/api/v1/add_skills", params: skill_info
      expect(response).to be_successful
      expect(response.status).to eq(201)

      response_body = JSON.parse(response.body, symbolize_names: true)
    end
  end
  
  describe "sad paths", :vcr do 
    it "creates user skills in the database for the user_id that is passed" do 
    user1 = create(:user, id: 1)
    user2 = create(:user, id: 2)
    
      skill_info = {
        "user_id": "3",
        "skills": [
          {
            "name": "skiing",
            "proficiency": "1"
          },
          {
            "name": "ping pong",
            "proficiency": "4"
          }
        ]
      }

      post "/api/v1/add_skills", params: skill_info
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body).to have_key(:error)
      expect(response_body[:error]).to eq('User not found.')
    end 
  end
end