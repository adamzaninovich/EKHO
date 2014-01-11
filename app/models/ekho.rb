module EKHO
  class Sonos
    attr_reader :system
    delegate :devices, :speakers, to: :system

    def initialize
      @system = ::Sonos::System.new
    end

    def get_devices
      @devices ||= begin
        groups = {}
        pairs = {}
        accessories = []
        speakers = []
        devices.each do |device|
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

        { groups: groups,
          pairs: pairs,
          speakers: speakers,
          accessories: accessories }
      end
    end

    def get_device device_id
      @device = system.devices.select do |device|
        device.name.parameterize == device_id
      end.first
    end

  end
end
