module EKHO
  class Sonos
    attr_reader :system
    delegate :devices, :speakers, to: :system

    def initialize
      @system = ::Sonos::System.new
    end

    def get_device device_id
      @device = system.devices.select do |device|
        device.name.parameterize == device_id
      end.first
    end

  end
end
