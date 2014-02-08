require "net/http"
require "uri"

class SparkUpdateTrackWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: false

  recurrence do
    minutely.second_of_minute 0, 15, 30, 45
  end

  def device_id
    'living-room'
  end

  def perform
    User.where(provider: 'spark').each do |user|
      track = TrackUpdate.find_or_init_with user_id: user.id, device_id: device_id
      unless track.persisted?
        track.persisted? ? track.touch : track.save
        update_spark! track.title, track.artist
      end
    end
  end

  private

  def update_spark! title, artist
    message = format_for_lcd artist, title
    Rails.logger.info "Sending Message to Spark: #{message}"
    SparkMessageSender.new.send message
    Rails.logger.info "DONE"
  end

  def format_for_lcd line1, line2
    "#{format_line line1}#{format_line line2}"
  end

  def format_line text
    text.slice(0, 16).ljust 16
  end

end

class SparkMessageSender
  def initialize device_id=ENV["SPARK_CORE_DEVICE_ID"], access_token=ENV["SPARK_CORE_ACCESS_TOKEN"]
    @uri = URI.parse "https://api.spark.io/v1/devices/#{device_id}/print"
    @access_token = access_token
  end

  def send message
    Net::HTTP.post_form @uri, access_token: @access_token, message: "#{message}"
  end
end
