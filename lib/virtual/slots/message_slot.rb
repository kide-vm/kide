module Virtual

  # The current Message is one of four objects the virtual machine knows
  #
  # Slots represent instance variables of objects, so MessageSlots
  # represent instance variables of Message objects.
  # The Message has a layout as per the constant above

  class MessageSlot < Slot
    def initialize type  , value = nil
      super(type , value )
    end
    def object_name
      :message
    end
  end

  # named classes exist for slots that often accessed

  # Return is the return of MessageSlot
  class Return < MessageSlot
    def initialize type , value = nil
      super( type , value  )
    end
  end

  # Self is the self in MessageSlot
  class Self < MessageSlot
    def initialize type , value = nil
      super( type , value  )
    end
  end

  # MessageName of the current message
  class MessageName < MessageSlot
    def initialize type , value = nil
      super( type , value  )
    end
  end

  # NewMessageName of the next message
  class ArgSlot < MessageSlot
    def initialize index , type , value = nil
      @index = index
      super( type , value )
    end
    attr_reader :index
  end


end
