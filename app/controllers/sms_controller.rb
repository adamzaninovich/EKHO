class SmsController < ApplicationController
  # disables csrf
  skip_before_action :verify_authenticity_token

  def control
    if params['session']
      action = params['session']['initialText'].downcase
      robot = action =~ /ifttt/
      commands = tropo_commands message(perform action), robot
      render json: commands
    else
      render nothing: true
    end
  end

  def devices
    device = sonos.get_device(params[:id]) || speaker
    title = device.now_playing[:title]
    artist = device.now_playing[:artist]
    render text: "#{artist}\\#{title}"
  end

  def next
    speaker.next
    render nothing: true
  end

  private

  def speaker
    @speaker ||= sonos.get_device 'living-room'
  end

  def perform action
    view = ActionView::Base.new
    case action
    when /system/
      m = ["There are"]
      m << view.pluralize(sonos.groups.count, 'group') if sonos.groups.any?
      m << view.pluralize(sonos.pairs.count, 'pair') if sonos.pairs.any?
      m << view.pluralize(sonos.speakers.count, 'speaker') if sonos.speakers.any?
      m << "and #{view.pluralize sonos.accessories.count, 'accessory'}" if sonos.accessories.any?
      m << "in the system"
      m.join ' '
    when /what.*vol/
      "The volume is set to #{speaker.volume}"
    when /(current|playing)/
      playing = speaker.now_playing
      "Currently playing: #{playing[:title]} by #{playing[:artist]} (#{playing[:current_position]}/#{playing[:track_duration]})"
    when /play/
      speaker.play
      control_action "played"
    when /(pause|stop|sta+hp)/
      sonos.speakers.each &:pause
      multi_control_action "paused"
    when /next/
      speaker.next
      control_action "advanced to the next track"
    when /prev/
      speaker.previous
      control_action "reverted to the previous track"
    when /vol.*up/
      if speaker.volume >= 90
        speaker.volume = 100
      else
        speaker.volume += 10
      end
      control_action "increased in volume"
    when /vol.*down/
      if speaker.volume <= 10
        speaker.volume = 0
      else
        speaker.volume -= 10
      end
      control_action "decreased in volume"
    else
      nil
    end
  end

  def perform_all action
    view = ActionView::Base.new
    case action
    when /system/
      m = ["There are"]
      m << view.pluralize(sonos.groups.count, 'group') if sonos.groups.any?
      m << view.pluralize(sonos.pairs.count, 'pair') if sonos.pairs.any?
      m << view.pluralize(sonos.speakers.count, 'speaker') if sonos.speakers.any?
      m << view.pluralize(sonos.accessories.count, 'accessory') if sonos.accessories.any?
      m << "in the system"
      m.join ' '
    when /what.*vol/
      sonos.speakers.map do |speaker|
        "The #{speaker.name} volume is set to #{speaker.volume}"
      end.join "\n"
    when /(current|playing)/
      sonos.speakers.map do |speaker|
        playing = speaker.now_playing
        "The #{speaker.name} is playing #{playing[:title]} by #{playing[:artist]} (#{playing[:current_position]}/#{playing[:track_duration]})"
      end.join "\n"
    when /play/
      sonos.speakers.each &:play
      multi_control_action "played"
    when /(pause|stop)/
      sonos.speakers.each &:pause
      multi_control_action "paused"
    when /next/
      sonos.speakers.each &:next
      multi_control_action "advanced to the next track"
    when /prev/
      sonos.speakers.each &:previous
      multi_control_action "reverted to the previous track"
    when /vol.*up/
      sonos.speakers.each do |speaker|
        if speaker.volume >= 90
          speaker.volume = 100
        else
          speaker.volume += 10
        end
      end
      multi_control_action "increased in volume"
    when /vol.*down/
      sonos.speakers.each do |speaker|
        if speaker.volume <= 10
          speaker.volume = 0
        else
          speaker.volume -= 10
        end
      end
      multi_control_action "decreased in volume"
    else
      nil
    end
  end

  def multi_control_action message
    if sonos.speakers.count == 1
      "#{sonos.speakers.first.name} was #{message}"
    else
      "#{sonos.speakers.map(&:name).join(', ')} were #{message}"
    end
  end

  def control_action message
    "#{speaker.name} was #{message}"
  end

  def message performed
    if sonos.speakers.any?
      if performed.present?
        performed
      else
        "Sorry, that action is not supported"
      end
    else
      "Sorry no speakers were found"
    end
  end

  def tropo_commands message, robot=false
    if robot
      { tropo: [ { hangup: nil } ] }
    else
      { tropo: [ { say: {value: message} }, { hangup: nil } ] }
    end
  end
end
