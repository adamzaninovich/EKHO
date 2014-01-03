class DevicesController < ApplicationController

  def index
    @devices = sonos.devices
  end

  def show
    @device = device_for_id params[:id]
  end

  def now_playing
    @device = device_for_id params[:id]
  end

  # controls

  def pause
    device = device_for_id params[:id]
    device.pause
  end

  def play
    device = device_for_id params[:id]
    device.play
  end

  def next
    device = device_for_id params[:id]
    device.next
  end

  def previous
    device = device_for_id params[:id]
    device.previous
  end

  def vol_up
    device = device_for_id params[:id]
    device.volume += 10
  end

  def vol_down
    device = device_for_id params[:id]
    if device.volume > 10
      device.volume -= 10
    else
      device.volume = 1
    end
  end

  private

  def device_for_id device_id
    sonos.devices.select do |device|
      device.name.parameterize == device_id
    end.first
  end

  def sonos
    @sonos ||= Sonos::System.new
  end

end
