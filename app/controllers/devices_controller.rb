class DevicesController < ApplicationController

  def index
    @devices = sonos.get_devices
  end

  def show
    @device = sonos.get_device params[:id]
  end

  def now_playing
    @poll = true
    @device = sonos.get_device params[:id]
  end

  # controls

  def pause
    @device = sonos.get_device params[:id]
    @device.pause
    render "now_playing"
  end

  def play
    @device = sonos.get_device params[:id]
    @device.play
    render "now_playing"
  end

  def next
    @device = sonos.get_device params[:id]
    @device.next
    render "now_playing"
  end

  def previous
    @device = sonos.get_device params[:id]
    @device.previous
    render "now_playing"
  end

  def vol_up
    @device = sonos.get_device params[:id]
    @device.volume += 10
    render "now_playing"
  end

  def vol_down
    @device = sonos.get_device params[:id]
    if @device.volume > 10
      @device.volume -= 10
    else
      @device.volume = 0
    end
    render "now_playing"
  end

  private

  def sonos
    @sonos ||= EKHO::Sonos.new
  end

end
