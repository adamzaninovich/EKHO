module DevicesHelper
  def in_seconds timecode
    hours, minutes, seconds = *timecode.split(':').map(&:to_i)
    hours*60*60 + minutes*60 + seconds
  end
  def format_time timecode
    hours, minutes, seconds = *timecode.split(':').map(&:to_i)
    if hours > 0
      timecode
    elsif seconds > 30
      "#{minutes}:#{seconds.to_s.rjust 2, '0'}"
    end
  end
  def percent_played now_playing
    elapsed = in_seconds now_playing[:current_position]
    total = in_seconds now_playing[:track_duration]
    100.0*elapsed/total
  end
end
