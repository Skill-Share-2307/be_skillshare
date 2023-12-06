require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do 
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end 

  describe 'relationships' do 
    it { should have_many(:user_meetings) }
    it { should have_many(:meetings).through(:user_meetings) }
  end

  describe "class methods" do
    describe "#remote_users" do 
      it "returns all users that have the attribute 'is_remote' set to true" do 
        user1 = User.create(first_name: "Steve", last_name: "Jobs", email: "steve@gmail.com", street: "1234 Street", city: "Cupertino", state: "CA", zipcode: "12345", lat: "1.12", lon: "1.12", is_remote: "true", about: "I am a very good programmer")
        user2 = User.create(first_name: "Ethan", last_name: "Bustamante", email: "Ethan@gmail.com", street: "1234 Street", city: "Denver", state: "CO", zipcode: "12345", lat: "1.12", lon: "1.12", is_remote: "true", about: "I am a also very good programmer")
        user3 = User.create(first_name: "Tyler", last_name: "Blackmon", email: "tyler#gmail.com", street: "1234 Street", city: "CO springs", state: "CO", zipcode: "12345", lat: "1.12", lon: "1.12", is_remote: "false", about: "I enjoy long walks on the beach")

        expect(User.remote_users).to eq([user1, user2])
      end
    end
  end

  describe "instance methods" do
    describe "#get_coords" do
      it "finds and saves coordinates to a user when a user is saved without coordinates" do
        stub = File.read('spec/fixtures/geocoding_response.json')
        stub_request(:get, "https://api.geoapify.com/v1/geocode/search?apiKey=#{Rails.application.credentials.geoapify[:api_key]}&format=json&text=5935%20Dublin%20Blvd%20%23100,%20Colorado%20Springs,%20Colorado%2080923").
          to_return(status: 200, body: stub)

        user = User.create(
          first_name: "Kiwi",
          last_name: "Bird",
          street: "5935 Dublin Blvd #100",
          city: "Colorado Springs",
          state: "Colorado",
          zipcode: "80923",
          is_remote: false,
          email: "kiwibird@gmail.com"
        )
        expect(user.lat).to eq(38.92589009854805)
        expect(user.lon).to eq(-104.71769185732973)
      end
    end
  end 
end
