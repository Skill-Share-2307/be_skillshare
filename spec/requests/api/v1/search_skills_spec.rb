require 'rails_helper'

RSpec.describe "Search skills endpoint", type: :request do 
  before :each do
    @user1 = User.create(first_name: "Steve", last_name: "Jobs", email: "steve@gmail.com", street: "1234 Street", city: "Cupertino", state: "CA", zipcode: "12345", lat: "1.12", lon: "1.12", is_remote: "true", about: "I am a very good programmer")
    @user2 = User.create(first_name: "Ethan", last_name: "Bustamante", email: "Ethan@gmail.com", street: "1234 Street", city: "Denver", state: "CO", zipcode: "12345", lat: "1.12", lon: "1.12", is_remote: "true", about: "I am a also very good programmer")
    @user3 = User.create(first_name: "Tyler", last_name: "Blackmon", email: "tyler#gmail.com", street: "1234 Street", city: "CO springs", state: "CO", zipcode: "12345", lat: "1.12", lon: "1.12", is_remote: "false", about: "I enjoy long walks on the beach")
    
    @steveskill1 = Skill.create(name: "Apple", proficiency: 5, user_id: @user1.id)
    @steveskill2 = Skill.create(name: "Swift", proficiency: 5, user_id: @user1.id)
    @steveskill3 = Skill.create(name: "knitting", proficiency: 3, user_id: @user1.id)

    @ethanskill1 = Skill.create(name: "Ruby", proficiency: 5, user_id: @user2.id)
    @ethanskill2 = Skill.create(name: "Rails", proficiency: 5, user_id: @user2.id)
    @ethanskill3 = Skill.create(name: "knitting", proficiency: 1, user_id: @user2.id) 

    @tylerskill1 = Skill.create(name: "Ruby", proficiency: 5, user_id: @user3.id)
    @tylerskill1 = Skill.create(name: "Piano", proficiency: 3, user_id: @user3.id)
  end

  describe "when I sent a query to '/api/v1/search_skills' " do 
    it "returns all the users with their skills" do
      get "/api/v1/search_skills", params: {query: "knitting", user_id: @user1.id}

      expect(response).to be_successful
      expect(response.status).to eq(200)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:data].count).to eq(2)

      users = response_body[:data]
      steve = users[0]

      expect(steve[:attributes][:first_name]).to eq("Steve")
      expect(steve[:attributes][:last_name]).to eq("Jobs")
      expect(steve[:attributes][:is_remote]).to eq(true)

      user1_skills = steve[:attributes][:skills]
      expect(user1_skills.count).to eq(3)
    end

    it "returns all the users with given skills if provided with a query that has multiple skills" do 
      get "/api/v1/search_skills", params: {query: "knitting, piano", user_id: @user1.id}

      expect(response).to be_successful
      expect(response.status).to eq(200)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:data].count).to eq(3)
    end

    it "returns all users based on both the skill and if they are remote" do 
      get "/api/v1/search_skills", params: {query: "knitting", is_remote: true, user_id: @user1.id}

      expect(response).to be_successful
      expect(response.status).to eq(200)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:data].count).to eq(2)

      includes_tyler = response_body[:data].any? { |user| user[:attributes][:first_name] == "Tyler"}
      expect(includes_tyler).to eq(false)
    end

    it "includes the distance from the current user to each searched user if the current user's id is passed as a param" do
      current_user = User.create!(first_name: "Chicken", last_name: "Bird", email: "chicken@gmail.com", street: "1234 Street", city: "CO springs", state: "CO", zipcode: "12345", lat: 1.12, lon: 1.12, is_remote: false, about: "I enjoy long walks on the beach")
      found_user = User.create!(first_name: "Kiwi", last_name: "Bird", email: "kiwi@gmail.com", street: "1234 Street", city: "CO springs", state: "CO", zipcode: "12345", lat: 1.25, lon: 1.32, is_remote: false, about: "I enjoy long walks on the beach")
      found_user_skill = Skill.create!(name: "Testing", proficiency: 5, user_id: found_user.id)

      get "/api/v1/search_skills", params: {query: "testing", is_remote: false, user_id: current_user.id}

      expect(response).to be_successful
      expect(response.status).to eq(200)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body).to be_a Hash
      expect(response_body).to have_key(:data)
      expect(response_body[:data]).to be_an Array

      response_body[:data].each do |user|
        expect(user).to be_a Hash
        expect(user).to have_key(:attributes)
        expect(user[:attributes]).to be_a Hash

        attributes = user[:attributes]
        expect(attributes).to have_key(:distance)
        expect(attributes[:distance]).to be_an Integer
      end
    end
  end

  describe "sad paths" do 
    it "returns a message if no users are found" do
      get "/api/v1/search_skills", params: {query: "rocket science", user_id: @user1.id}

      expect(response).to be_successful
      expect(response.status).to eq(200)

      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:data]).to eq([])
    end

    it "returns a message if a blank parameter is passed" do
      get "/api/v1/search_skills", params: {query: ""}

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:error]).to eq("Please enter a skill to search for.")
    end

    it "returns an error if no user_id is provided" do
      get "/api/v1/search_skills", params: {query: "rocket science"}

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:error]).to eq("User could not be found")
    end
  end
end