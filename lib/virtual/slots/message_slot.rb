module Virtual

  MESSAGE_CALLER = 0
  MESSAGE_RETURN_ADDRESS = 1
  MESSAGE_EXCEPTION_ADDRESS = 2
  MESSAGE_SELF = 3
  MESSAGE_NAME = 4
  MESSAGE_RETURN_VALUE = 5
  MESSAGE_FRAME = 6
  MESSAGE_PAYLOAD = 7

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

  # Return is the MessageSlot(MESSAGE_RETURN_VALUE)
  class Return < MessageSlot
    def initialize type = Unknown, value = nil
      super( MESSAGE_RETURN_VALUE , type , value  )
    end
  end

  # Self is the MessageSlot(MESSAGE_SELF)
  class Self < MessageSlot
    def initialize type = Unknown, value = nil
      super( MESSAGE_SELF , type , value  )
    end
  end

  # MessageName of the current message
  class MessageName < MessageSlot
    def initialize type = Unknown, value = nil
      super( MESSAGE_NAME , type , value  )
    end
  end
end
