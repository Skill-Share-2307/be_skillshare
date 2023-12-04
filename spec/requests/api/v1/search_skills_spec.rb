require 'rails_helper'

RSpec.describe "Search skills endpoint", type: :request do 
  before :each do
    @user1 = User.create(first_name: "Steve", last_name: "Jobs", email: "steve@gmail.com", street: "1234 Street", city: "Cupertino", state: "CA", zipcode: "12345", lat: "1.12", lon: "1.12", is_remote: "true", about: "I am a very good programmer")
    @user2 = User.create(first_name: "Ethan", last_name: "Bustamante", email: "Ethan@gmail.com", street: "1234 Street", city: "Denver", state: "CO", zipcode: "12345", lat: "1.12", lon: "1.12", is_remote: "true", about: "I am a also very good programmer")
    @user3 = User.create(first_name: "Tyler", last_name: "Blackmon", email: "tyler#gmail.com", street: "1234 Street", city: "CO springs", state: "CO", zipcode: "12345", lat: "1.12", lon: "1.12", is_remote: "true", about: "I enjoy long walks on the beach")
    
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
      get "/api/v1/search_skills", params: {query: "knitting"}

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
      get "/api/v1/search_skills", params: {query: "knitting, piano"}

      expect(response).to be_successful
      expect(response.status).to eq(200)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:data].count).to eq(3)
    end
  end

  describe "sad paths" do 
    it "returns a message if no users are found" do
      get "/api/v1/search_skills", params: {query: "rocket science"}

      expect(response).to be_successful
      expect(response.status).to eq(200)

      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:data]).to eq([])
    end

    it "returns a message if no users are found" do
        get "/api/v1/search_skills", params: {query: ""}
  
        expect(response).to_not be_successful
        expect(response.status).to eq(400)
  
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body[:error]).to eq("Please enter a skill to search for.")
    end
  end
end