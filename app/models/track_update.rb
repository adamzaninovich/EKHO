class TrackUpdate < ActiveRecord::Base
  belongs_to :user
  attr_reader :device

  def self.find_or_init_with params
    previous = where(params).last
    current = new(params)
    if previous.present? &&  previous.title == current.title && previous.artist == current.artist
      previous
    else
      current
    end
  end

  def initialize params
    super
    self.title = device.now_playing[:title]
    self.artist = device.now_playing[:artist]
    self.position = device.now_playing[:current_position]
  end

  def device
    sonos.get_device device_id
  end

  private

  def sonos
    @sonos ||= EKHO::Sonos.new
  end

end
