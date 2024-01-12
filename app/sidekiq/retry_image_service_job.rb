class RetryImageServiceJob
  include Sidekiq::Job

  def perform(id)
    user = User.find(id)
    begin
      image = ImageService.new.user_image
    rescue Faraday::ConnectionFailed, JSON::ParserError
      RetryImageServiceJob.perform_in(5.minutes, id)
    else
      if !image[:errors]
        user.update(profile_picture: image[:data][:attributes][:raw_image])
      else
        RetryImageServiceJob.perform_in(5.minutes, id)
      end
    end
  end
end
