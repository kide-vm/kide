module Virtual

  #TODO : this constant approach is a bit old, from before PArfait adapter
  #      nowadays these are unneccessary as we can resolve the names by using the
  #      layout of the class. (get Class from space)
  TYPE_INDEX = 0
  LAYOUT_INDEX = 1
  CALLER_INDEX = 2
  RETURN_INDEX = 3
  EXCEPTION_INDEX = 4
  SELF_INDEX = 5
  NAME_INDEX = 6
  FRAME_INDEX = 7
  ARGUMENT_START = 8

  # The current Message is one of four objects the virtual machine knows
  #
  # Slots represent instance variables of objects, so MessageSlots
  # represent instance variables of Message objects.
  # The Message has a layout as per the constant above

  class MessageSlot < Slot
    def initialize index , type = Unknown , value = nil
      super(index ,type , value )
    end
  end

  # named classes exist for slots that often accessed

  # Return is the MessageSlot(RETURN_INDEX)
  class Return < MessageSlot
    def initialize type = Unknown, value = nil
      super( RETURN_INDEX , type , value  )
    end
  end

  # Self is the MessageSlot(SELF_INDEX)
  class Self < MessageSlot
    def initialize type = Unknown, value = nil
      super( SELF_INDEX , type , value  )
    end
  end

  # MessageName of the current message
  class MessageName < MessageSlot
    def initialize type = Unknown, value = nil
      super( NAME_INDEX , type , value  )
    end
  end
end
