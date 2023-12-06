require 'rails_helper'

RSpec.describe SearchFacade do
  before(:each) do
    @current_user = User.create!(first_name: "Chicken", last_name: "Bird", email: "chicken@gmail.com", street: "1234 Street", city: "CO springs", state: "CO", zipcode: "12345", lat: 1.12, lon: 1.12, is_remote: false, about: "I enjoy long walks on the beach")
    @found_user = User.create!(first_name: "Kiwi", last_name: "Bird", email: "kiwi@gmail.com", street: "1234 Street", city: "CO springs", state: "CO", zipcode: "12345", lat: 1.25, lon: 1.32, is_remote: false, about: "I enjoy long walks on the beach")
    @found_user_skill = Skill.create!(name: "Testing", proficiency: 5, user_id: @found_user.id)

    @params = {
      is_remote: false,
      user_id: @current_user.id,
      query: "testing"
    }
  end

  it "exists and has unreadable attributes on initialize" do
    facade = SearchFacade.new(@params)
    expect(facade).to be_a SearchFacade
    expect {facade.is_remote}.to raise_error(NoMethodError)
    expect {facade.current_user_id}.to raise_error(NoMethodError)
    expect {facade.query}.to raise_error(NoMethodError)
  end

  describe "#build_users" do
    it "returns an array of SearchedUserPoro objects" do
      facade = SearchFacade.new(@params)
      users = facade.build_users
      expect(users).to be_an Array
      expect(users.first).to be_a SearchedUserPoro
      expect(users.first.id).to eq(@found_user.id)
    end
  end
end