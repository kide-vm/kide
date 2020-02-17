module SlotMachine

  class Slotted

    def self.for(object , slots = nil)
      case object
      when :message
        SlottedMessage.new(slots)
      when Constant
        SlottedConstant.new(object , slots)
      when Parfait::Object , Risc::Label
        SlottedObject.new(object , slots)
      else
        raise "not supported type #{object}:#{object.class}"
      end
    end

    # The first in a possible chain of slots, that name instance variables in the
    # previous object
    attr_reader :slots

    def initialize( slots = nil )
      return unless slots
      raise "stopped" unless slots.is_a?(Array)
      first = slots.shift
      raise "ended" unless first
      @slots = Slot.new(first)
      until(slots.empty?)
        @slots.set_next( Slot.new( slots.shift ))
      end
    end

    def slots_length
      return 0 unless @slots
      1 + @slots.length
    end

    def set_next(slot)
      if(@slots)
        @slots.set_next(slot)
      else
        @slots = slot
      end
    end

    def to_s
      names = known_name.to_s
      names += ".#{@slots}" if @slots
      names
    end


  end
end
