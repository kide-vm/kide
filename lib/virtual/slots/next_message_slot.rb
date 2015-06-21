module Virtual

  # The next Message is one of four objects the virtual machine knows
  #
  # Slots represent instance variables of objects, so NextMessageSlots
  # represent instance variables of NextMessage objects.
  # The Message has a layout as per the constant above

  class NextMessageSlot < Slot
    def initialize index , type = Unknown, value = nil
      super(index , type , value )
    end
  end

  # named classes exist for slots that often accessed

  # NextReturn is the NextMessageSlot(RETURN_INDEX)
  class NextReturn < NextMessageSlot
    def initialize type = Unknown, value = nil
      super( RETURN_INDEX, type , value  )
    end
  end

  # NextSelf is the NextMessageSlot(SELF_INDEX)
  class NextSelf < NextMessageSlot
    def initialize type = Unknown, value = nil
      super( SELF_INDEX , type , value  )
    end
  end

  # NextMessageName of the next message
  class NextMessageName < NextMessageSlot
    def initialize type = Unknown, value = nil
      super( NAME_INDEX, type , value )
    end
  end
end
