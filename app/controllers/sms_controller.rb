class SmsController < ApplicationController
  # disables csrf
  skip_before_action :verify_authenticity_token

  def control
    if params['session']
      action = params['session']['initialText'].downcase.parameterize
      robot = action =~ /ifttt/
      commands = tropo_commands message(perform action), robot
      render json: commands
    else
      render nothing: true
    end
  end

  private

  def sonos
    @sonos ||= EKHO::Sonos.new
  end

  def perform action
    case action
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
      control_action "played"
    when /(pause|stop)/
      sonos.speakers.each &:pause
      control_action "paused"
    when /next/
      sonos.speakers.each &:next
      control_action "advanced to the next track"
    when /prev/
      sonos.speakers.each &:previous
      control_action "reverted to the previous track"
    when /vol.*up/
      sonos.speakers.each do |speaker|
        if speaker.volume >= 90
          speaker.volume = 100
        else
          speaker.volume += 10
        end
      end
      control_action "increased in volume"
    when /vol.*down/
      sonos.speakers.each do |speaker|
        if speaker.volume <= 10
          speaker.volume = 0
        else
          speaker.volume -= 10
        end
      end
      control_action "decreased in volume"
    else
      nil
    end
  end

  def control_action message
    if sonos.speakers.count == 1
      "#{sonos.speakers.first.name} was #{message}"
    else
      "#{sonos.speakers.map(&:name).join(', ')} were #{message}"
    end
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
