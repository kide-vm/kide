module Virtual

  # The next Message is one of four objects the virtual machine knows
  #
  # Slots represent instance variables of objects, so NewMessageSlots
  # represent instance variables of NewMessage objects.
  # The Message has a layout as per the constant above

  class NewMessageSlot < Slot
    def initialize type = Unknown, value = nil
      super( type , value )
    end
    def object_name
      :new_message
    end
  end

  # named classes exist for slots that often accessed

  # NewReturn is the return of NewMessageSlot
  class NewReturn < NewMessageSlot
    def initialize type = Unknown, value = nil
      super( type , value  )
    end
  end

  # NewSelf is the self of NewMessageSlot
  class NewSelf < NewMessageSlot
    def initialize type = Unknown, value = nil
      super( type , value  )
    end
  end

  # NewMessageMethod of the next message
  class NewMessageMethod < NewMessageSlot
    def initialize type = Unknown, value = nil
      super( type , value )
    end
  end

  # NewMessageMethod of the next message
  class NewArgSlot < NewMessageSlot
    def initialize index , type = Unknown, value = nil
      @index = index
      super( type , value )
    end
    attr_reader :index
  end

end
