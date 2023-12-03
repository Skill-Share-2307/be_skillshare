require 'rails_helper'

RSpec.describe GeocodingService do
  it "exists" do
    service = GeocodingService.new

    expect(service).to be_a GeocodingService
  end

  describe "#geocode_address" do
    it "returns the geocoding of the provided address" do
      stub = File.read('spec/fixtures/geocoding_response.json')
      stub_response(:get, "https://api.geoapify.com/v1/geocode/search?text=5935 Dublin Blvd #100, 
      Colorado Springs, CO 80923&format=json&apiKey=#{Rails.application.credentials.geoapify[:api_key]}").
        with_response(status: 200, body: stub)

      
      response = GeocodingService.new.geocode_address("5935 Dublin Blvd #100, Colorado Springs, CO 80923")
      geocode = JSON.parse(response, symbolize_names: true)
      expect(geocode).to be_a Hash
      expect(geocode).to have_key(:results)
      expect(geocode[:results]).to be_an Array

      geocode[:results].each do |result|
        expect(result).to be_a Hash
        expect(result).to have_key(:lon)
        expect(result[:lon]).to be_a Float
        expect(result).to have_key(:lat)
        expect(result[:lat]).to be_a Float
      end
    end
  end
end