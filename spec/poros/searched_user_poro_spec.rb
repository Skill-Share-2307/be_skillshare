require 'rails_helper'

RSpec.describe SearchedUserPoro do
  it "exists and all attributes are built correctly" do
    current_user = User.create!(first_name: "Chicken", last_name: "Bird", email: "chicken@gmail.com", street: "1234 Street", city: "CO springs", state: "CO", zipcode: "12345", lat: 1.12, lon: 1.12, is_remote: false, about: "I enjoy long walks on the beach")
    searched_user = User.create!(first_name: "Kiwi", last_name: "Bird", email: "kiwi@gmail.com", street: "1234 Street", city: "CO springs", state: "CO", zipcode: "12345", lat: 1.25, lon: 1.32, is_remote: false, about: "I enjoy long walks on the beach")
    found_user_skill = Skill.create!(name: "Testing", proficiency: 5, user_id: searched_user.id)

    expected_skills = [{
      name: "Testing",
      proficiency: 5
    }]

    poro = SearchedUserPoro.new(searched_user, current_user)
    expect(poro).to be_a SearchedUserPoro
    expect(poro.id).to eq(searched_user.id)
    expect(poro.first_name).to eq(searched_user.first_name)
    expect(poro.last_name).to eq(searched_user.last_name)
    expect(poro.is_remote).to eq(searched_user.is_remote)
    expect(poro.skills).to eq(expected_skills)
    expect(poro.distance).to eq(16)
  end
end