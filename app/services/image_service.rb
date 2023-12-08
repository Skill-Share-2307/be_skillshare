class ImageService
  def conn
    Faraday.new(
      url: Rails.configuration.x.image_service_url
    )
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def user_image
    get_url("/api/v1/images")
  end
end