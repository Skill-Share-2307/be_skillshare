require "rails_helper"

RSpec.describe "creae user endpoint" do
  describe "when I send a post request to '/api/v1/users' with a body" do 
    it "creates a user and send back all the user's data" do 
      expect(User.count).to eq(0)

        user_info = {
          "first_name": "Antoine",
          "last_name": "Aube",
          "email": "yetanother@gmail.com",
          "address": "12345 street st.",
          "lat": "1.12",
          "lon": "1.12",
          "is_remote": "true"
      }

      post "/api/v1/users", params: user_info
      expect(response).to be_successful
      expect(response.status).to eq(201)

      response_body = JSON.parse(response.body, symbolize_names: true)
      user = User.last

      expect(response_body).to have_key(:data)
      expect(response_body[:data]).to be_a(Hash)
      expect(response_body[:data]).to have_key(:id)
      expect(response_body[:data][:id]).to eq(user.id.to_s)
      expect(response_body[:data]).to have_key(:type)
      expect(response_body[:data][:type]).to eq("user")
      expect(response_body[:data]).to have_key(:attributes)

      attributes = response_body[:data][:attributes] 

      expect(attributes).to have_key(:first_name)
      expect(attributes[:first_name]).to eq(user.first_name)
      expect(attributes).to have_key(:last_name)
      expect(attributes[:last_name]).to eq(user.last_name)
      expect(attributes).to have_key(:email)
      expect(attributes[:email]).to eq(user.email)
      expect(attributes).to have_key(:address)  
      expect(attributes[:address]).to eq(user.address)  
      expect(attributes).to have_key(:lat)
      expect(attributes[:lat]).to eq(user.lat)
      expect(attributes).to have_key(:lon)
      expect(attributes[:lon]).to eq(user.lon)
      expect(attributes).to have_key(:is_remote)
      expect(attributes[:is_remote]).to eq(user.is_remote)

      expect(User.count).to eq(1)
    end
  end

  describe "sad paths" do 
    it "returns an error if the email is already taken" do 
      user = create(:user, email:"taken@gmail.com")
      expect(User.count).to eq(1)

      user_info = {
          "first_name": "Antoine",
          "last_name": "Aube",
          "email": "taken@gmail.com",
          "address": "12345 street st.",
          "lat": "1.12",
          "lon": "1.12",
          "is_remote": "true"
      }

      post "/api/v1/users", params: user_info
      # require 'pry';binding.pry
      expect(response).to_not be_successful
      expect(response.status).to eq(422)
      
      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body).to have_key(:error)
      expect(response_body[:error]).to eq("Email has already been taken")
    end
  end
end