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

    attr_reader :slots
    # is an array of symbols, that specifies the first the object, and then the Slot.
    # The first element is either a known type name (Capitalized symbol of the class name) ,
    # or the symbol :message
    # And subsequent symbols must be instance variables on the previous type.
    # Examples:  [:message , :receiver] or [:Space , :next_message]
    def initialize( slots)
      raise "No slots #{object}" unless slots
      slots = [slots] unless slots.is_a?(Array)
      @slots =  slots
    end

    def to_s
      names = [known_name] + @slots
      "[#{names.join(', ')}]"
    end


  end
end
