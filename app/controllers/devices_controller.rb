class DevicesController < ApplicationController

  def index
    @devices = sonos.devices
  end

  def show
    get_device
  end

  def now_playing
    @poll = true
    get_device
  end

  # controls

  def pause
    get_device
    @device.pause
    render "now_playing"
  end

  def play
    get_device
    @device.play
    render "now_playing"
  end

  def next
    get_device
    @device.next
    render "now_playing"
  end

  def previous
    get_device
    @device.previous
    render "now_playing"
  end

  def vol_up
    get_device
    @device.volume += 10
    render "now_playing"
  end

  def vol_down
    get_device
    if @device.volume > 10
      @device.volume -= 10
    else
      @device.volume = 0
    end
    render "now_playing"
  end

  private

  def get_device device_id=params[:id]
    @device = sonos.devices.select do |device|
      device.name.parameterize == device_id
    end.first
  end

  def sonos
    @sonos ||= Sonos::System.new
  end

end
