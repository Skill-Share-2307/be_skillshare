class GeocodingService
  def conn
    Faraday.new(
      url: Rails.configuration.x.geocoding_service_url
    )
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def geocode_address(address)
    safe_address = CGI.escape(address)
    get_url("/api/v1/coordinates?address=#{safe_address}")
  end
end