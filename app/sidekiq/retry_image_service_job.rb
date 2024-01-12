class RetryImageServiceJob
  include Sidekiq::Job

  def perform(id)
    puts "hi there :) I would try to grab an image for ID: #{id}!"
  end
end
