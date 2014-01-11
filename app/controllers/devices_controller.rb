class DevicesController < ApplicationController

  def index
    groups = {}
    pairs = {}
    accessories = []
    speakers = []
    sonos.devices.each do |device|
      if device.group_master
        (groups[device.group_master] ||= []) << device
      else
        accessories << device
      end
    end
    groups.each do |master, slaves|
      if slaves.count == 1
        speakers << slaves.first
        groups.delete master
      elsif slaves.map(&:name).uniq.count == 1
        pairs[master] = slaves
        groups.delete master
      end
    end

    @devices = { pairs: pairs, groups: groups, accessories: accessories, speakers: speakers }
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
