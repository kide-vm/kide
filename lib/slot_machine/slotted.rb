module SlotMachine

  class Slotted

    def self.for(object , slots)
      case object
      when :message
        SlottedMessage.new(slots)
      when Constant
        SlottedConstant.new(object , slots)
      when Parfait::Object , Risc::Label
        SlottedObject.new(object , slots)
      else
        raise "not supported type #{object}"
      end
    end

    # The first in a possible chain of slots, that name instance variables in the
    # previous object
    attr_reader :slot

    def initialize( slots )
      raise "No slots #{object}" unless slots
      slots = [slots] unless slots.is_a?(Array)
      first = slots.shift
      @slot = Slot.new(first)
      until(slots.empty?)
        @slot.set_next( Slot.new( slots.shift ))
      end
    end

    def to_s
      names = known_name.to_s
      names += ".#{@slot}" if @slot
      names
    end


  end
end
