require "net/http"
require "uri"

class SparkUpdateTrackWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: false

  recurrence do
    minutely.second_of_minute 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55
  end

  def device_id
    'bedroom'
  end

  def perform
    User.where(provider: 'spark').each do |user|
      track = TrackUpdate.find_or_init_with user_id: user.id, device_id: device_id
      if track.persisted?
        Rails.logger.info "Not sending #{track.title} by #{track.artist}."
      else
        Rails.logger.info "Sending #{track.title} by #{track.artist}."
        track.save
        update_spark! user.uid, track.title, track.artist
      end
    end
  end

  def update_spark! device_id, title, artist
    if device_id
      message = format_for_lcd artist, title
      Rails.logger.info "Sending Message to Spark: #{message}"
      response = SparkMessageSender.new(device_id).send message
      Rails.logger.info response.inspect
      Rails.logger.info "DONE"
    else
      Rails.logger.error "No Device ID!"
    end
  end

  def format_for_lcd line1, line2
    "#{line1}\\#{line2}"
  end

end

class SparkMessageSender
  def initialize device_id=ENV["SPARK_CORE_DEVICE_ID"], access_token=ENV["SPARK_CORE_ACCESS_TOKEN"]
    @uri = URI.parse "https://api.spark.io/v1/devices/#{device_id}/print"
    @access_token = access_token
  end

  def send message
    if @access_token
      Net::HTTP.post_form @uri, access_token: @access_token, message: "#{message}"
    else
      Rails.logger.error "No Spark Access Token!"
    end
  end
end
