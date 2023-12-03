require 'rails_helper'

RSpec.describe GeocodingService do
  it "exists" do
    service = GeocodingService.new

    expect(service).to be_a GeocodingService
  end

  describe "#geocode_address" do
    it "returns the geocoding of the provided address" do
      stub = File.read('spec/fixtures/geocoding_response.json')
      stub_request(:get, "https://api.geoapify.com/v1/geocode/search?apiKey=#{Rails.application.credentials.geoapify[:api_key]}&format=json&text=5935%20Dublin%20Blvd%20%23100,%20Colorado%20Springs,%20CO%2080923").
        to_return(status: 200, body: stub)

      
      response = GeocodingService.new.geocode_address("5935 Dublin Blvd #100, Colorado Springs, CO 80923")
      expect(response).to be_a Hash
      expect(response).to have_key(:results)
      expect(response[:results]).to be_an Array

      response[:results].each do |result|
        expect(result).to be_a Hash
        expect(result).to have_key(:lon)
        expect(result[:lon]).to be_a Float
        expect(result).to have_key(:lat)
        expect(result[:lat]).to be_a Float
      end
    end
  end
end