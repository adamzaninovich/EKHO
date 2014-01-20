class GlassDeviceControlWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3, backtrace: true

  def perform item_id
    device_id, action = extract_from_item_id item_id
    case action
    when /play/
      sonos.get_device(device_id).play
    when /pause/
      sonos.system.speakers.each &:pause
    when /next/
      sonos.get_device(device_id).next
    when /previous/
      sonos.get_device(device_id).previous
    end
  end

  private

  def sonos
    @sonos ||= EKHO::Sonos.new
  end

  def extract_from_item_id item_id
    item_id.split ':'
  end

end
