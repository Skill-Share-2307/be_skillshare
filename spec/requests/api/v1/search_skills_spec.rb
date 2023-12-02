require 'rails_helper'

RSpec.descripe "Search skills endpoint", type: :request do 
  describe "when I sent a query to '/api/v1/search_skills' " do 
    it "returns all the users with their skills" do
      get "/api/v1/search_skills", params: {skill: "knitting"}

      expect(response).to be_successful
      expect(response.status).to eq(200)
    end
  end
end