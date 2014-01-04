class DevicesController < ApplicationController

  def index
    @devices = sonos.devices
  end

  def show
    get_device
  end

  def now_playing
    get_device
    render 'now_playing', format: :js
  end

  # controls

  def pause
    get_device
    @device.pause
  end

  def play
    get_device
    @device.play
  end

  def next
    get_device
    @device.next
  end

  def previous
    get_device
    @device.previous
  end

  def vol_up
    get_device
    @device.volume += 10
  end

  def vol_down
    get_device
    if @device.volume > 10
      @device.volume -= 10
    else
      @device.volume = 0
    end
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
