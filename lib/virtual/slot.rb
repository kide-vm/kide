module Virtual
  # Slots are named, or rather indexed, storage locations that are typed.
  # Four of those locations exist and those correspond to subclasses:
  # - the message that has been received: MessageSlot
  # - the frame of the method that is executing (local variables): FrameSlot
  # - self as an object: SelfSlot
  # - a message that will be sent, NewMessageSlot
  
  # additionally frame, self and return are slots in Message and NewMessage

  class Slot < Value
    RETURN = 0
    SELF = 1
    FRAME = 2
    NAME = 3
    MESSAGE_PAYLOAD = 4

    attr_accessor :index , :type , :value
    private #abstract base class
    def initialize index , type , value
      @index = index
      @type = type
      @value = value
    end
  end
  
  class MessageSlot < Slot
    def initialize index , type = Mystery , value = nil
      super(index + MESSAGE_PAYLOAD ,type , value )
    end
  end
  class FrameSlot < Slot
    def initialize index , type = Mystery, value = nil
      super
    end
  end
  class SelfSlot < Slot
    def initialize index , type = Mystery, value = nil
      super
    end
  end
  class NewMessageSlot < Slot
    def initialize index , type = Mystery, value = nil
      super(index + MESSAGE_PAYLOAD , type , value )
    end
  end

  class Return < MessageSlot
    def initialize type = Mystery, value = nil
      super( RETURN - MESSAGE_PAYLOAD, type , value  )
    end
  end
  class Self < MessageSlot
    def initialize type = Mystery, value = nil
      super( SELF - MESSAGE_PAYLOAD , type , value  )
    end
  end
  class Name < MessageSlot
    def initialize type = Mystery, value = nil
      super( NAME - MESSAGE_PAYLOAD , type , value  )
    end
  end

  class NewReturn < NewMessageSlot
    def initialize type = Mystery, value = nil
      super( RETURN - MESSAGE_PAYLOAD, type , value  )
    end
  end
  class NewSelf < NewMessageSlot
    def initialize type = Mystery, value = nil
      super( SELF - MESSAGE_PAYLOAD , type , value  )
    end
  end
  class NewName < NewMessageSlot
    def initialize type = Mystery, value = nil
      super( NAME - MESSAGE_PAYLOAD , type , value )
    end
  end

end
