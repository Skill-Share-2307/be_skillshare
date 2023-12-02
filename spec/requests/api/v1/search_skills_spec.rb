require 'rails_helper'

RSpec.describe "Search skills endpoint", type: :request do 
  describe "when I sent a query to '/api/v1/search_skills' " do 
    before :each do
      @user1 = User.create(first_name: "Steve", last_name: "Jobs", email: "steve@gmail.com", address: "12345 street st.", lat: "1.12", lon: "1.12", is_remote: "true", about: "I am a very good programmer")
      @user2 = User.create(first_name: "Ethan", last_name: "Bustamante", email: "Ethan@gmail.com", address: "Ethan street st.", lat: "1.12", lon: "1.12", is_remote: "true", about: "I am a also very good programmer")
      @user3 = User.create(first_name: "Tyler", last_name: "Blackmon", email: "tyler#gmail.com", address: "Tyler street st.", lat: "1.12", lon: "1.12", is_remote: "true", about: "I enjoy long walks on the beach")

      @steveskill1 = Skill.create(name: "Apple", proficiency: 5, user_id: @user1.id)
      @steveskill2 = Skill.create(name: "Swift", proficiency: 5, user_id: @user1.id)
      @steveskill3 = Skill.create(name: "knitting", proficiency: 3, user_id: @user1.id)

      @ethanskill1 = Skill.create(name: "Ruby", proficiency: 5, user_id: @user2.id)
      @ethanskill2 = Skill.create(name: "Rails", proficiency: 5, user_id: @user2.id)
      @ethanskill3 = Skill.create(name: "knitting", proficiency: 1, user_id: @user2.id) 

      @tylerskill1 = Skill.create(name: "Ruby", proficiency: 5, user_id: @user3.id)
    end
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
  end
end